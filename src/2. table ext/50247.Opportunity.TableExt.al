tableextension 50247 tableextension50247 extends Opportunity
{
    // 11.11.2015 EB.P7 #T066
    //   Bugfix Oportunity Assign Quote
    // 
    // 19.03.2014 Elva Baltic P15 #F002 MMG7.00
    //   Functions: *Prompt*
    // 
    // //10-08-2007 EDMS P3
    //   * Mandatory fields control
    fields
    {
        modify("Contact Company No.")
        {
            TableRelation = Contact WHERE(Type = CONST(" "));
        }
        modify("Sales Document No.")
        {
            TableRelation = IF (Sales Document Type=CONST(Quote)) "Sales Header".No. WHERE (Document Type=CONST(Quote),
                                                                                            Sell-to Contact No.=FIELD(Contact No.))
                                                                                            ELSE IF (Sales Document Type=CONST(Order)) "Sales Header".No. WHERE (Document Type=CONST(Order),
                                                                                                                                                                 Sell-to Contact No.=FIELD(Contact No.))
                                                                                                                                                                 ELSE IF (Sales Document Type=CONST(Posted Invoice)) "Sales Invoice Header".No. WHERE (Sell-to Contact No.=FIELD(Contact No.));
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 16)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Current Sales Cycle Stage"(Field 17)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Estimated Value (LCY)"(Field 18)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Probability %"(Field 19)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Calcd. Current Value (LCY)"(Field 20)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Chances of Success %"(Field 21)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Completed %"(Field 22)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Estimated Closing Date"(Field 28)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Interactions"(Field 30)".



        //Unsupported feature: Code Insertion on ""Wizard Estimated Value (LCY)"(Field 9504)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            //20.03.2013 EDMS >>
            IF "Wizard Currency Code" <> '' THEN BEGIN
              UpdateCurrencyFactor;
              Currency.GET("Wizard Currency Code");
              "Wizard Estimated Value" := ROUND("Wizard Estimated Value (LCY)" * CurrencyFactor,Currency."Amount Rounding Precision")
            END ELSE
              "Wizard Estimated Value" := "Wizard Estimated Value (LCY)";
            //20.03.2013 EDMS <<
            */
        //end;
        field(25006000;"Wizard Estimated Value";Decimal)
        {
            Caption = 'Wizard Estimated Value';

            trigger OnValidate()
            begin
                //20.03.2013 EDMS >>
                IF "Wizard Currency Code" <> '' THEN BEGIN
                  UpdateCurrencyFactor;
                  Currency.GET("Wizard Currency Code");
                  "Wizard Estimated Value (LCY)" := ROUND("Wizard Estimated Value" / CurrencyFactor,Currency."Amount Rounding Precision")
                END ELSE
                  "Wizard Estimated Value (LCY)" := "Wizard Estimated Value";
                //20.03.2013 EDMS <<
            end;
        }
        field(25006020;"Wizard Currency Code";Code[10])
        {
            Caption = 'Wizard Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                UpdateCurrencyFactor;
                VALIDATE("Wizard Estimated Value (LCY)");
            end;
        }
    }

    //Unsupported feature: Variable Insertion (Variable: Selected) (VariableCollection) on "AssignQuote(PROCEDURE 6)".



    //Unsupported feature: Code Modification on "AssignQuote(PROCEDURE 6)".

    //procedure AssignQuote();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        Cont.GET("Contact No.");

        IF (Cont.Type = Cont.Type::Person) AND (Cont."Company No." = '') THEN
          ERROR(
            Text005,
            Cont.TABLECAPTION,Cont."No.");

        IF Cont.Type = Cont.Type::Person THEN
          Cont.GET(Cont."Company No.");

        ContactBusinessRelation.SETRANGE("Contact No.",Cont."No.");
        ContactBusinessRelation.SETRANGE("Link to Table",ContactBusinessRelation."Link to Table"::Customer);
        IF ContactBusinessRelation.ISEMPTY THEN BEGIN
          IF (Cont.Type = Cont.Type::Company) AND (PAGE.RUNMODAL(0,CustTemplate) = ACTION::LookupOK) THEN
            CustTemplateCode := CustTemplate.Code
          ELSE
            Cont.CreateCustomer(Cont.ChooseCustomerTemplate);
        END;

        TESTFIELD(Status,Status::"In Progress");

        IF NOT SalesHeader.GET(SalesHeader."Document Type"::Quote,"Sales Document No.") THEN BEGIN
          SalesHeader.SETRANGE("Sell-to Contact No.","Contact No.");
          SalesHeader.INIT;
          SalesHeader."Document Type" := SalesHeader."Document Type"::Quote;
          SalesHeader.INSERT(TRUE);
          SalesHeader.VALIDATE("Salesperson Code","Salesperson Code");
          SalesHeader.VALIDATE("Campaign No.","Campaign No.");
          SalesHeader."Opportunity No." := "No.";
          SalesHeader."Order Date" := GetEstimatedClosingDate;
          SalesHeader."Shipment Date" := SalesHeader."Order Date";
          SalesHeader.VALIDATE("Sell-to Customer Template Code",CustTemplateCode);
          SalesHeader.MODIFY;
          "Sales Document Type" := "Sales Document Type"::Quote;
          "Sales Document No." := SalesHeader."No.";
          MODIFY;
        END ELSE
          ERROR(Text011);
        PAGE.RUN(PAGE::"Sales Quote",SalesHeader);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        Cont.GET("Contact No.");

        IF (Cont.Type = Cont.Type::Company) AND (Cont."Company No." = '') THEN
        #4..7
        IF Cont.Type = Cont.Type::Company THEN
        #9..13
          IF (Cont.Type = Cont.Type::" ") AND (PAGE.RUNMODAL(0,CustTemplate) = ACTION::LookupOK) THEN
        #15..20
        Selected := ChooseProfile;
        IF (Selected) > 0 THEN BEGIN
          IF NOT SalesHeader.GET(SalesHeader."Document Type"::Quote,"Sales Document No.") THEN BEGIN
            //11.11.2015 EB.P7 #T066>>
            SalesHeader.SETRANGE("Sell-to Contact No.","Contact No.");
            SalesHeader.INIT;
            SalesHeader."Document Profile" := Selected - 1;
            //11.11.2015 EB.P7 #T066<<
            SalesHeader."Document Type" := SalesHeader."Document Type"::Quote;
            SalesHeader.INSERT(TRUE);
            SalesHeader.VALIDATE("Salesperson Code","Salesperson Code");
            SalesHeader.VALIDATE("Campaign No.","Campaign No.");
            SalesHeader."Opportunity No." := "No.";
            SalesHeader."Order Date" := GetEstimatedClosingDate;
            SalesHeader."Shipment Date" := SalesHeader."Order Date";
          SalesHeader.VALIDATE("Sell-to Customer Template Code",CustTemplateCode);
            SalesHeader.MODIFY;
            "Sales Document Type" := "Sales Document Type"::Quote;
            "Sales Document No." := SalesHeader."No.";
            MODIFY;
          END ELSE
            ERROR(Text011);
          PAGE.RUN(PAGE::"Sales Quote",SalesHeader);
        END;
        */
    //end;


    //Unsupported feature: Code Modification on "FinishWizard(PROCEDURE 18)".

    //procedure FinishWizard();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        "Wizard Step" := Opp."Wizard Step"::" ";
        ActivateFirstStage := "Activate First Stage";
        "Activate First Stage" := FALSE;
        OppEntry."Chances of Success %" := "Wizard Chances of Success %";
        OppEntry."Estimated Close Date" := "Wizard Estimated Closing Date";
        OppEntry."Estimated Value (LCY)" := "Wizard Estimated Value (LCY)";

        "Wizard Chances of Success %" := 0;
        "Wizard Estimated Closing Date" := 0D;
        "Wizard Estimated Value (LCY)" := 0;
        #11..13

        InsertOpportunity(Rec,OppEntry,RMCommentLineTmp,ActivateFirstStage);
        DELETE;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..7
        //10.09.2009. EDMS P2 >>
        IF "Wizard Currency Code" <> '' THEN BEGIN
          OppEntry.VALIDATE("Currency Code", "Wizard Currency Code");
          OppEntry.VALIDATE("Estimated Value", "Wizard Estimated Value");
        END;
        //10.09.2009. EDMS P2 <<

        #8..16
        */
    //end;

    local procedure UpdateCurrencyFactor()
    var
        CurrExchRate: Record "330";
        CurrencyDate: Date;
    begin
        IF "Wizard Currency Code" <> '' THEN BEGIN
          CurrencyDate := WORKDATE;
          CurrencyFactor := CurrExchRate.ExchangeRate(CurrencyDate,"Wizard Currency Code");
        END ELSE
          CurrencyFactor := 0;
    end;

    procedure GetPromptProfile(): Boolean
    begin
        EXIT(SalesHeaderDef.GetPromptProfile);
    end;

    procedure SetPromptProfile(BoolValueToSet: Boolean)
    begin
        SalesHeaderDef.SetPromptProfile(BoolValueToSet);
    end;

    procedure CloseOpportunityAutomaticaly(CloseOppCode: Record "5094")
    var
        OppEntry: Record "5093" temporary;
    begin
        IF "No." <> '' THEN BEGIN
          TESTFIELD(Closed,FALSE);
          OppEntry.INIT;
          OppEntry.VALIDATE("Opportunity No.","No.");
          OppEntry."Sales Cycle Code" := "Sales Cycle Code";
          OppEntry."Contact No." := "Contact No.";
          OppEntry."Contact Company No." := "Contact Company No.";
          OppEntry."Salesperson Code" := "Salesperson Code";
          OppEntry."Campaign No." := "Campaign No.";
          OppEntry."Close Opportunity Code" := CloseOppCode.Code;
          CASE CloseOppCode.Type OF
            CloseOppCode.Type::Won:
              OppEntry."Action Taken" := OppEntry."Action Taken"::Won;
            CloseOppCode.Type::Lost:
              OppEntry."Action Taken" := OppEntry."Action Taken"::Lost;
          END;
          OppEntry.INSERT;
          OppEntry.InsertEntry(OppEntry,FALSE,FALSE);
        END;
    end;

    procedure ChooseProfile(): Integer
    var
        Selected: Integer;
    begin
        Selected := STRMENU(TextDlg001, 0);
        EXIT(Selected);
    end;

    var
        Currency: Record "4";
        SalesHeaderDef: Record "36";

    var
        TextDlg001: Label 'Default,Spare Parts Trade,Vehicles Trade';
        CurrencyFactor: Decimal;
}

