pageextension 50198 pageextension50198 extends "Contact List"
{
    // 11.02.2016 EB.P7
    //   Added Send SMS action
    // 20.07.2013 EDMS P8
    //   * Changed image for 'Vehicles' action
    layout
    {

        //Unsupported feature: Property Modification (SubPageLink) on "Control 128".

        addafter("Control 4")
        {
            field("Name 2"; Rec."Name 2")
            {
            }
            field(Address; Rec.Address)
            {
            }
        }
        addafter("Control 22")
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
            }
            field("Citizenship No."; "Citizenship No.")
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 44".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 55".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 50".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 3".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 76".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 67".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 49".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 51".



        //Unsupported feature: Code Modification on "Action 39.OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD(Type,Type::Person);
        ContJobResp.SETRANGE("Contact No.","No.");
        PAGE.RUNMODAL(PAGE::"Contact Job Responsibilities",ContJobResp);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        TESTFIELD(Type,Type::Company);
        ContJobResp.SETRANGE("Contact No.","No.");
        PAGE.RUNMODAL(PAGE::"Contact Job Responsibilities",ContJobResp);
        */
        //end;
        addfirst("Action 29")
        {
            action("<Action1101904000>")
            {
                Caption = 'Vehicles';
                Image = Delivery;
                RunObject = Page 25006055;
                RunPageLink = Contact No.=FIELD(No.);
                RunPageView = SORTING(Contact No.);
            }
        }
        addafter("Action 55")
        {
            action("<Action1101904001>")
            {
                Caption = 'Vehicle Sales Quotes';
                Image = Quote;
                RunObject = Page 25006471;
                                RunPageLink = Sell-to Contact No.=FIELD(No.);
                RunPageView = SORTING(Document Type,Sell-to Contact No.);
            }
            action("<Action1101914001>")
            {
                Caption = 'Spare Parts Sales Quotes';
                Image = Quote;
                RunObject = Page 25006817;
                                RunPageLink = Sell-to Customer No.=FIELD(No.);
                RunPageView = SORTING(Document Type,Sell-to Contact No.);
            }
            action("<Action1101924001>")
            {
                Caption = 'Service Quotes';
                Image = Quote;
                RunObject = Page 25006254;
                                RunPageLink = Sell-to Customer No.=FIELD(No.);
                RunPageView = SORTING(Document Type,Sell-to Contact No.);
            }
        }
        addfirst("Action 30")
        {
            action("Send SMS")
            {
                Caption = 'Send SMS';
                Image = SendTo;

                trigger OnAction()
                var
                    SendSMS: Page "25006404";
                                 UserSetup: Record "91";
                                 SalespersonCode: Code[10];
                begin
                    UserSetup.GET(USERID);
                    IF UserSetup."Salespers./Purch. Code" <> '' THEN
                      SalespersonCode := UserSetup."Salespers./Purch. Code"
                    ELSE
                      SalespersonCode := Rec."Salesperson Code";

                    SendSMS.SetSalespersonCode(SalespersonCode);
                    SendSMS.SetContactNo(Rec."No.");
                    SendSMS.SetPhoneNo(Rec."Mobile Phone No.");
                    SendSMS.RUN;
                end;
            }
        }
        addafter("Action 31")
        {
            action("New Sales Quote (Veh)")
            {
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;
                RunObject = Page 25006471;
                                RunPageLink = Sell-to Contact No.=FIELD(No.);
            }
        }
        addafter("Action 1900800206")
        {
            action("Sales Contact Reminder")
            {
                RunObject = Report 33020016;
            }
            action("Contact Cover Sheet")
            {
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 5055;
            }
        }
    }


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        EnableFields;
        StyleIsStrong := Type = Type::Company;

        IF CRMIntegrationEnabled THEN
          CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        EnableFields;
        StyleIsStrong := Type = Type::" ";
        #3..5
        */
    //end;


    //Unsupported feature: Code Modification on "EnableFields(PROCEDURE 1)".

    //procedure EnableFields();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CompanyGroupEnabled := Type = Type::Company;
        PersonGroupEnabled := Type = Type::Person;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        CompanyGroupEnabled := Type = Type::" ";
        PersonGroupEnabled := Type = Type::Company;
        */
    //end;

    local procedure GetSelectionFilter(): Code[250]
    var
        LclCnct: Record "5050";
        FirstCnct: Code[20];
        LastCnctNo: Code[20];
        SelectionFilter: Code[250];
        CnctCount: Integer;
        MoreCnct: Boolean;
    begin
        CurrPage.SETSELECTIONFILTER(LclCnct);
        CnctCount := LclCnct.COUNT;
        IF CnctCount > 0 THEN BEGIN
          LclCnct.FIND('-');
          WHILE CnctCount > 0 DO BEGIN
            CnctCount := CnctCount - 1;
            LclCnct.MARKEDONLY(FALSE);
            FirstCnct := LclCnct."No.";
            LastCnctNo := FirstCnct;
            MoreCnct := (CnctCount > 0);
            WHILE MoreCnct DO
              IF LclCnct.NEXT = 0 THEN
                MoreCnct := FALSE
              ELSE
                IF NOT LclCnct.MARK THEN
                  MoreCnct := FALSE
              ELSE BEGIN
                LastCnctNo := LclCnct."No.";
                CnctCount := CnctCount - 1;
                IF CnctCount = 0 THEN
                  MoreCnct := FALSE;
              END;
            IF SelectionFilter <> '' THEN
              SelectionFilter := SelectionFilter + '|';
            IF FirstCnct = LastCnctNo THEN
              SelectionFilter := SelectionFilter + FirstCnct
            ELSE
              SelectionFilter := SelectionFilter + FirstCnct + '..' + LastCnctNo;
            IF CnctCount > 0 THEN BEGIN
              LclCnct.MARKEDONLY(TRUE);
              LclCnct.NEXT;
            END;
          END;
        END;
        EXIT(SelectionFilter);
    end;
}

