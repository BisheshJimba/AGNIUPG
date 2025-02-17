tableextension 50248 tableextension50248 extends "Opportunity Entry"
{
    // 20.11.2014 EB.P8 MERGE
    //   Added field 25006009
    // 05-09-2007 EDMS P3
    //  * Added 2 fields for foreign currency (ACY)
    fields
    {
        modify("Contact Company No.")
        {
            TableRelation = Contact WHERE(Type = CONST(" "));
        }
        modify("Close Opportunity Code")
        {
            TableRelation = IF (Action Taken=CONST(Won)) "Close Opportunity Code" WHERE (Type=CONST(Won))
                            ELSE IF (Action Taken=CONST(Lost)) "Close Opportunity Code" WHERE (Type=CONST(Lost));
        }


        //Unsupported feature: Code Insertion on ""Date of Change"(Field 9)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
                //EDMS1.0.00 >>
                                                                            UpdateCurrencyFactor;
            VALIDATE("Estimated Value (LCY)")
            //EDMS1.0.00 <<
            */
        //end;


        //Unsupported feature: Code Insertion on ""Estimated Value (LCY)"(Field 14)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            //EDMS1.0.00 >>
            IF "Currency Code"<>'' THEN BEGIN
              Currency.GET("Currency Code");
              "Estimated Value" := ROUND("Estimated Value (LCY)" * "Currency Factor",Currency."Amount Rounding Precision")
            END ELSE
              "Estimated Value" := "Estimated Value (LCY)";
            //EDMS1.0.00 <<
            */
        //end;


        //Unsupported feature: Code Insertion on ""Calcd. Current Value (LCY)"(Field 15)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            //20.03.2013 EDMS >>
            IF "Currency Code" <> '' THEN BEGIN
              Currency.GET("Currency Code");
              "Calcd. Current Value" := ROUND("Calcd. Current Value (LCY)" / "Currency Factor",Currency."Amount Rounding Precision")
            END ELSE
              "Calcd. Current Value" := "Calcd. Current Value (LCY)";
            //20.03.2013 EDMS <<
            */
        //end;
        field(25006000;"Estimated Value";Decimal)
        {
            Caption = 'Estimated Value';

            trigger OnValidate()
            begin
                TESTFIELD("Currency Factor");
                IF "Currency Code"<>'' THEN
                  Currency.GET("Currency Code");
                "Estimated Value (LCY)" := ROUND("Estimated Value" / "Currency Factor",Currency."Amount Rounding Precision")
            end;
        }
        field(25006010;"Calcd. Current Value";Decimal)
        {
            Caption = 'Calcd. Current Value';

            trigger OnValidate()
            begin
                IF "Currency Code" <> '' THEN BEGIN
                  Currency.GET("Currency Code");
                  "Calcd. Current Value (LCY)" := ROUND("Calcd. Current Value" / "Currency Factor",Currency."Amount Rounding Precision")
                END ELSE
                  "Calcd. Current Value (LCY)" := "Calcd. Current Value";
            end;
        }
        field(25006020;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                //IF "Currency Code" <> xRec."Currency Code" THEN BEGIN
                  UpdateCurrencyFactor;
                  VALIDATE("Estimated Value (LCY)");
                  VALIDATE("Calcd. Current Value (LCY)");
                //END
            end;
        }
        field(25006030;"Currency Factor";Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0:15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "Currency Factor" <> xRec."Currency Factor" THEN
                  VALIDATE("Estimated Value (LCY)")
            end;
        }
    }


    //Unsupported feature: Code Modification on "UpdateEstimates(PROCEDURE 2)".

    //procedure UpdateEstimates();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF SalesCycleStage.GET("Sales Cycle Code","Sales Cycle Stage") THEN BEGIN
          SalesCycle.GET("Sales Cycle Code");
          CASE SalesCycle."Probability Calculation" OF
        #4..13
          "Calcd. Current Value (LCY)" := "Estimated Value (LCY)" * "Probability %" / 100;
          IF ("Estimated Close Date" = "Date of Change") OR ("Estimated Close Date" = 0D) THEN
            "Estimated Close Date" := CALCDATE(SalesCycleStage."Date Formula","Date of Change");
        END;

        CASE "Action Taken" OF
          "Action Taken"::Won:
            BEGIN
              Opp.GET("Opportunity No.");
              IF SalesHeader.GET(SalesHeader."Document Type"::Quote,Opp."Sales Document No.") THEN
                "Calcd. Current Value (LCY)" := GetSalesDocValue(SalesHeader);

              "Completed %" := 100;
              "Chances of Success %" := 100;
              "Probability %" := 100;
            END;
          "Action Taken"::Lost:
            BEGIN
              "Calcd. Current Value (LCY)" := 0;
              "Completed %" := 100;
              "Chances of Success %" := 0;
              "Probability %" := 0;
            END;
        END;
        MODIFY;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..16
          //10.09.2009. EDMS P2 >>
          "Calcd. Current Value" := "Estimated Value" * "Probability %" / 100;
          //10.09.2009. EDMS P2 <<
        #17..22
              IF SalesHeader.GET(SalesHeader."Document Type"::Quote,Opp."Sales Document No.") THEN BEGIN
                "Calcd. Current Value (LCY)" := GetSalesDocValue(SalesHeader);
                //10.09.2009. EDMS P2 >>
                "Calcd. Current Value" := GetSalesDocValue2(SalesHeader);
                //10.09.2009. EDMS P2 <<
              END ELSE BEGIN
                "Calcd. Current Value (LCY)" := "Estimated Value (LCY)";
                //10.09.2009. EDMS P2 >>
                "Calcd. Current Value" := "Estimated Value";
                //10.09.2009. EDMS P2 <<
              END;
        #25..32
              //10.09.2009. EDMS P2 >>
              "Calcd. Current Value" := 0;
              //10.09.2009. EDMS P2 <<
        #33..38
        */
    //end;


    //Unsupported feature: Code Modification on "TestCust(PROCEDURE 5)".

    //procedure TestCust();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        Cont.GET("Contact No.");

        IF Cont.Type = Cont.Type::Person THEN
          IF NOT Cont.GET(Cont."Company No.") THEN
            ERROR(Text000,Cont."No.");

        ContBusRel.SETRANGE("Contact No.",Cont."No.");
        ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);

        IF NOT ContBusRel.FINDFIRST THEN
          Cont.CreateCustomer('');
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        Cont.GET("Contact No.");

        IF Cont.Type = Cont.Type::Company THEN
        #4..11
        */
    //end;

    procedure GetSalesDocValue2(SalesHeader: Record "36"): Decimal
    var
        TotalSalesLine: Record "37";
        TotalSalesLineLCY: Record "37";
        SalesPost: Codeunit "80";
        VATAmount: Decimal;
        VATAmountText: Text[30];
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        TotalAdjCostLCY: Decimal;
    begin
        SalesPost.SumSalesLines(
          SalesHeader,0,TotalSalesLine,TotalSalesLineLCY,
          VATAmount,VATAmountText,ProfitLCY,ProfitPct,TotalAdjCostLCY);
        EXIT(TotalSalesLine.Amount);
    end;

    local procedure UpdateCurrencyFactor()
    var
        CurrencyDate: Date;
    begin
        IF "Currency Code" <> '' THEN BEGIN
          IF ("Date of Change" = 0D) THEN
            CurrencyDate := WORKDATE
          ELSE
            CurrencyDate := "Date of Change";

          "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate,"Currency Code");
        END ELSE
          "Currency Factor" := 0;
    end;

    var
        CurrExchRate: Record "330";
        Currency: Record "4";
}

