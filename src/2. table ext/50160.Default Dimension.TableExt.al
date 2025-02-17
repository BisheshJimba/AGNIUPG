tableextension 50160 tableextension50160 extends "Default Dimension"
{
    // 24.02.2010 EDMS P2
    //   * Added code UpdateGlobalDimCode
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Table ID=CONST(13)) Salesperson/Purchaser
                            ELSE IF (Table ID=CONST(15)) "G/L Account"
                            ELSE IF (Table ID=CONST(18)) Customer
                            ELSE IF (Table ID=CONST(23)) Vendor
                            ELSE IF (Table ID=CONST(27)) Item
                            ELSE IF (Table ID=CONST(152)) "Resource Group"
                            ELSE IF (Table ID=CONST(156)) Resource
                            ELSE IF (Table ID=CONST(167)) Job
                            ELSE IF (Table ID=CONST(270)) "Bank Account"
                            ELSE IF (Table ID=CONST(413)) "IC Partner"
                            ELSE IF (Table ID=CONST(5071)) Campaign
                            ELSE IF (Table ID=CONST(5200)) Employee
                            ELSE IF (Table ID=CONST(5600)) "Fixed Asset"
                            ELSE IF (Table ID=CONST(5628)) Insurance
                            ELSE IF (Table ID=CONST(5903)) "Service Order Type"
                            ELSE IF (Table ID=CONST(5904)) "Service Item Group"
                            ELSE IF (Table ID=CONST(5940)) "Service Item"
                            ELSE IF (Table ID=CONST(5714)) "Responsibility Center"
                            ELSE IF (Table ID=CONST(5800)) "Item Charge"
                            ELSE IF (Table ID=CONST(99000754)) "Work Center"
                            ELSE IF (Table ID=CONST(5105)) "Customer Template"
                            ELSE IF (Table ID=CONST(849)) "Cash Flow Manual Revenue"
                            ELSE IF (Table ID=CONST(850)) "Cash Flow Manual Expense"
                            ELSE IF (Table ID=CONST(25006068)) "Deal Type";
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Table Caption"(Field 6)".

    }

    //Unsupported feature: Variable Insertion (Variable: ServiceLabor) (VariableCollection) on "UpdateGlobalDimCode(PROCEDURE 25)".



    //Unsupported feature: Code Modification on "UpdateGlobalDimCode(PROCEDURE 25)".

    //procedure UpdateGlobalDimCode();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CASE TableID OF
      DATABASE::"G/L Account":
        UpdateGLAccGLobalDimCode(GlobalDimCodeNo,AccNo,NewDimValue);
    #4..34
        UpdateNeutrPayGLobalDimCode(GlobalDimCodeNo,AccNo,NewDimValue);
      DATABASE::"Cash Flow Manual Revenue":
        UpdateNeutrRevGLobalDimCode(GlobalDimCodeNo,AccNo,NewDimValue);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..37

    //24.10.2012 EDMS P2 >>
      DATABASE::"Service Labor":
        UpdateServiceLaborEDMSGLobalDimCode(GlobalDimCodeNo,"No.",NewDimValue);
    //24.10.2012 EDMS P2 <<

    END;
    */
    //end;

    local procedure UpdateServiceLaborEDMSGLobalDimCode(GlobalDimCodeNo: Integer; ServiceLaborNo: Code[20]; NewDimValue: Code[20])
    var
        ServiceLabor: Record "25006121";
    begin
        IF ServiceLabor.GET(ServiceLaborNo) THEN BEGIN
            CASE GlobalDimCodeNo OF
                1:
                    ServiceLabor."Global Dimension 1 Code" := NewDimValue;
                2:
                    ServiceLabor."Global Dimension 2 Code" := NewDimValue;
            END;
            ServiceLabor.MODIFY(TRUE);
        END;
    end;
}

