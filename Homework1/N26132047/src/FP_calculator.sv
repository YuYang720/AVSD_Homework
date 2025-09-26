module FP_calculator ( // should be pipeline, but no time left
    input  [31:0] operand1,
    input  [31:0] operand2,
    input  [4:0]  func7_bits,  // func7[6:2]
    output logic [31:0] fp_result
);

    // 內部信號
    logic operation; // 0: addition, 1: subtraction
    logic sign_fprs1, sign_fprs2, sign_rslt;
    logic [7:0] exp_temp1, exp_temp2, exp_rslt;
    logic [50:0] frac_temp1, frac_temp2, frac_rslt;
    logic [7:0] exp_diff;
    logic [50:0] aligned_frac1, aligned_frac2;
    logic [50:0] normalized_frac;
    logic [7:0] normalized_exp;
    logic [50:0] rounded_frac;
    logic [7:0] rounded_exp;
    logic sticky, over_push, significant;
    logic fp_valid;

    // 決定運算類型
    always_comb begin
        case(func7_bits)
            `FADD_S: operation = 1'b0; // addition
            `FSUB_S: operation = 1'b1; // subtraction
            default: operation = 1'b0;
        endcase
    end

    // 提取輸入的符號位、指數、尾數
    always_comb begin
        sign_fprs1 = operand1[31];
        sign_fprs2 = operand2[31];
        exp_temp1 = operand1[30:23];
        exp_temp2 = operand2[30:23];
        frac_temp1 = {2'b01, operand1[22:0], 26'd0}; // 隱含的1 + 尾數 + 擴展位
        frac_temp2 = {2'b01, operand2[22:0], 26'd0};
    end

    // 對齊階段 (SHIFT)
    always_comb begin
        if (exp_temp1 > exp_temp2) begin
            exp_diff = exp_temp1 - exp_temp2;
            aligned_frac1 = frac_temp1;
            aligned_frac2 = frac_temp2 >> exp_diff;
            exp_rslt = exp_temp1;
            over_push = (exp_diff > 8'd26) ? 1'b1 : 1'b0;
        end else if (exp_temp2 > exp_temp1) begin
            exp_diff = exp_temp2 - exp_temp1;
            aligned_frac1 = frac_temp1 >> exp_diff;
            aligned_frac2 = frac_temp2;
            exp_rslt = exp_temp2;
            over_push = (exp_diff > 8'd26) ? 1'b1 : 1'b0;
        end else begin
            exp_diff = 8'd0;
            aligned_frac1 = frac_temp1;
            aligned_frac2 = frac_temp2;
            exp_rslt = exp_temp1;
            over_push = 1'b0;
        end
    end

    // 運算階段 (OPERATION)
    always_comb begin
        if (operation == 1'b0) begin // addition
            if (sign_fprs1 == sign_fprs2) begin
                frac_rslt = aligned_frac1 + aligned_frac2;
                sign_rslt = sign_fprs1;
            end else begin
                if (aligned_frac1 > aligned_frac2) begin
                    frac_rslt = aligned_frac1 - aligned_frac2;
                    sign_rslt = sign_fprs1;
                end else begin
                    frac_rslt = aligned_frac2 - aligned_frac1;
                    sign_rslt = sign_fprs2;
                end
            end
        end else begin // subtraction
            if (sign_fprs1 != sign_fprs2) begin
                frac_rslt = aligned_frac1 + aligned_frac2;
                sign_rslt = sign_fprs1;
            end else begin
                if (aligned_frac1 > aligned_frac2) begin
                    frac_rslt = aligned_frac1 - aligned_frac2;
                    sign_rslt = sign_fprs1;
                end else begin
                    frac_rslt = aligned_frac2 - aligned_frac1;
                    sign_rslt = ~sign_fprs2;
                end
            end
        end
    end

    // 正規化階段 (NORMALIZE)
    always_comb begin
        normalized_frac = frac_rslt;
        normalized_exp = exp_rslt;
        
        // 簡化的正規化 - 處理最常見的情況
        if (frac_rslt[50:49] == 2'b00) begin
            // 需要左移
            if (frac_rslt[48]) begin
                normalized_frac = frac_rslt << 1;
                normalized_exp = exp_rslt - 1;
            end else if (frac_rslt[47]) begin
                normalized_frac = frac_rslt << 2;
                normalized_exp = exp_rslt - 2;
            end else if (frac_rslt[46]) begin
                normalized_frac = frac_rslt << 3;
                normalized_exp = exp_rslt - 3;
            end else if (frac_rslt[45]) begin
                normalized_frac = frac_rslt << 4;
                normalized_exp = exp_rslt - 4;
            end else begin
                // 更多左移情況可以繼續添加
                normalized_frac = frac_rslt << 5;
                normalized_exp = exp_rslt - 5;
            end
        end else if (frac_rslt[50:49] == 2'b01) begin
            // 已經正規化
            normalized_frac = frac_rslt;
            normalized_exp = exp_rslt;
        end else begin
            // 需要右移
            normalized_frac = frac_rslt >> 1;
            normalized_exp = exp_rslt + 1;
        end
    end

    // 四捨五入階段 (ROUND)
    always_comb begin
        rounded_frac = normalized_frac;
        rounded_exp = normalized_exp;
        
        if (normalized_frac[25:24] == 2'b11) begin
            rounded_frac[50:24] = normalized_frac[50:24] + 1'b1;
        end else if (normalized_frac[25:24] == 2'b10) begin
            if (sticky) begin
                rounded_frac[50:24] = normalized_frac[50:24] + 2'b10;
            end else begin
                if (normalized_frac[26]) begin
                    rounded_frac[50:24] = normalized_frac[50:24] + 2'b10;
                end else begin
                    rounded_frac[50:24] = normalized_frac[50:24];
                end
            end
        end
        
        // 檢查四捨五入後是否需要再次正規化
        if (rounded_frac[50:49] != 2'b01) begin
            if (rounded_frac[50]) begin
                rounded_frac = rounded_frac >> 1;
                rounded_exp = normalized_exp + 1;
            end
        end
    end

    // 輔助信號
    always_comb begin
        significant = |rounded_frac[23:0];
        sticky = significant || over_push;
        
        if (rounded_frac[25:24] == 2'b00 || rounded_frac[25:24] == 2'b01) begin
            fp_valid = 1'b1;
        end else if (rounded_frac[25:24] == 2'b11) begin
            fp_valid = 1'b0;
        end else if (sticky) begin
            fp_valid = 1'b0;
        end else if (rounded_frac[26]) begin
            fp_valid = 1'b0;
        end else begin
            fp_valid = 1'b1;
        end
    end

    // 輸出結果
    always_comb begin
        if (func7_bits == `FADD_S || func7_bits == `FSUB_S) begin
            fp_result = {sign_rslt, rounded_exp, rounded_frac[48:26]};
        end else begin
            fp_result = 32'b0;
        end
    end

endmodule
