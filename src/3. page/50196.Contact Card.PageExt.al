pageextension 50196 pageextension50196 extends "Contact Card"
{
    // 11.02.2016 EB.P7
    //   Added Send SMS action
    // 09.01.2014 EDMS P8
    //   * Use SalesHeader.SetPromptProfile
    // 
    // 20.07.2013 EDMS P8
    //   * Changed image for 'Vehicles' action
    Caption = 'Reports';
    Editable = false;
    Editable = false;
    Editable = false;

    //Unsupported feature: Property Insertion (Name) on ""Contact Card"(Page 5050)".


    //Unsupported feature: Property Insertion (Name) on ""Contact Card"(Page 5050)".

    Caption = 'Model Interested In';
    Editable = false;

    //Unsupported feature: Property Insertion (Name) on ""Contact Card"(Page 5050)".

    PromotedActionCategories = 'New,Process,Report,Related Information,Pipeline';

    //Unsupported feature: Property Insertion (RefreshOnActivate) on ""Contact Card"(Page 5050)".

    layout
    {

        //Unsupported feature: Property Modification (Level) on "Address(Control 34)".


        //Unsupported feature: Property Modification (Name) on "Address(Control 34)".


        //Unsupported feature: Property Modification (SourceExpr) on "Address(Control 34)".


        //Unsupported feature: Property Modification (Level) on "Control 16".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 16".


        //Unsupported feature: Property Insertion (Name) on "Control 16".


        //Unsupported feature: Property Modification (Level) on "Control 18".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 18".


        //Unsupported feature: Property Modification (Level) on "Control 14".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 14".


        //Unsupported feature: Property Modification (Level) on "Control 12".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 31".

        modify("Control 10")
        {
            Visible = false;
        }
        modify("Control 117")
        {
            Visible = false;
        }

        //Unsupported feature: Property Deletion (ToolTipML) on "Address(Control 34)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Address(Control 34)".



        //Unsupported feature: Code Insertion on ""Contact Person"(Control 16)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*
        // CNY.CRM >>
        PipeLineDetails_G.RESET;
        PipeLineDetails_G.SETRANGE("Prospect No.","No.");
        IF PipeLineDetails_G.FINDSET THEN
        PipeLineDetails_G.MODIFYALL("Contact Person","Contact Person");
        // CNY.CRM <<
        */
        //end;

        //Unsupported feature: Property Deletion (ToolTipML) on "Control 16".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 16".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 18".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 18".


        //Unsupported feature: Property Deletion (Importance) on "Control 18".



        //Unsupported feature: Code Insertion on ""Model Interested In"(Control 14)".

        //trigger OnLookup(var Text: Text): Boolean
        //var
        //recProspectVehInfo: Record "33020151";
        //VehicleInterestedLists: Page "33020152";
        //begin
        /*
        BEGIN
          recProspectVehInfo.SETRANGE(recProspectVehInfo."Prospect No.","No.");
          VehicleInterestedLists.SETRECORD(recProspectVehInfo);
          VehicleInterestedLists.SETTABLEVIEW(recProspectVehInfo);
          VehicleInterestedLists.LOOKUPMODE(TRUE);
          IF VehicleInterestedLists.RUNMODAL = ACTION::LookupOK THEN
          BEGIN
            VehicleInterestedLists.GETRECORD(recProspectVehInfo);
            "Model Interested In":=recProspectVehInfo."Model Version No.";
          END
        END;
        */
        //end;

        //Unsupported feature: Property Deletion (ToolTipML) on "Control 14".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 14".



        //Unsupported feature: Code Insertion on ""Mobile No."(Control 36)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*
        // CNY.CRM >>
        PipeLineDetails_G.RESET;
        PipeLineDetails_G.SETRANGE("Prospect No.","No.");
        IF PipeLineDetails_G.FINDSET THEN
          PipeLineDetails_G.MODIFYALL("Mobile Phone No.","Mobile Phone No.");
        // CNY.CRM <<
        */
        //end;


        //Unsupported feature: Code Insertion on "Control 66".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*
        IRD := 'http://etds.ird.gov.np/pan_details.php?pan='+"VAT Registration No.";
        */
        //end;
        addafter("Control 8")
        {
            field("Salutation Code"; Rec."Salutation Code")
            {

                trigger OnValidate()
                begin
                    // CNY.CRM >>
                    PipeLineDetails_G.RESET;
                    PipeLineDetails_G.SETRANGE("Prospect No.", Rec."No.");
                    IF PipeLineDetails_G.FINDSET THEN
                        PipeLineDetails_G.MODIFYALL(Rec."Company Name", Rec.Name);
                    // CNY.CRM <<
                end;
            }
            field(Guarantor; Guarantor)
            {
            }
            field(Name; Rec.Name)
            {

                trigger OnValidate()
                begin
                    // CNY.CRM >>
                    BEGIN
                        PipeLineDetails_G.RESET;
                        PipeLineDetails_G.SETRANGE("Prospect No.", Rec."No.");
                        IF PipeLineDetails_G.FINDSET THEN
                            PipeLineDetails_G.MODIFYALL(Rec."Company Name", Rec.Name);
                        // CNY.CRM <<
                    END;
                end;
            }
            field("Name 2"; Rec."Name 2")
            {

                trigger OnValidate()
                begin
                    BEGIN
                        // CNY.CRM >>
                        PipeLineDetails_G.RESET;
                        PipeLineDetails_G.SETRANGE("Prospect No.", Rec."No.");
                        IF PipeLineDetails_G.FINDSET THEN
                            PipeLineDetails_G.MODIFYALL("Prospect Address", Rec.Address);
                        // CNY.CRM <<
                    END;
                end;
            }
            field(Address; Rec.Address)
            {
            }
            field("Address 2"; Rec."Address 2")
            {
            }
            field("Post Code"; Rec."Post Code")
            {
            }
            field(City; Rec.City)
            {
            }
        }
        addafter("Control 20")
        {
            field("Vehicle Required"; "Vehicle required")
            {
            }
        }
        addafter("Control 24")
        {
            field("Customer Type"; "Customer Type")
            {

                trigger OnLookup(var Text: Text): Boolean
                begin
                    // CNY.CRM >>
                    CRMMasterTemplate.RESET;
                    CRMMasterTemplate.SETRANGE("Master Options", CRMMasterTemplate."Master Options"::CustomerType);
                    CRMMasterTemplate.SETRANGE("Division Type", DivisionType);
                    CRMMasterTemplate.SETRANGE(Active, TRUE);
                    CustomerTypePage.SETTABLEVIEW(CRMMasterTemplate);
                    CustomerTypePage.LOOKUPMODE(TRUE);
                    IF CustomerTypePage.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        CustomerTypePage.GETRECORD(CRMMasterTemplate);
                        "Customer Type" := CRMMasterTemplate.Code;
                    END;
                    // CNY.CRM <<
                end;
            }
            field("Created Date"; "Created Date")
            {
            }
            field("Time Logged In"; "Time Logged In")
            {
            }
            field("Contact Creation Completed"; "Contact Creation Completed")
            {
            }
        }
        addafter("Control 40")
        {
            field("Citizenship No."; "Citizenship No.")
            {
            }
            field("Citizenship Issued District"; "Citizenship Issued District")
            {
            }
            field("Home Phone No."; Rec."Phone No.")
            {

                trigger OnValidate()
                begin
                    // CNY.CRM >>
                    PipeLineDetails_G.RESET;
                    PipeLineDetails_G.SETRANGE("Prospect No.", Rec."No.");
                    IF PipeLineDetails_G.FINDSET THEN
                        PipeLineDetails_G.MODIFYALL(Rec."Phone No.", Rec."Phone No.");
                    // CNY.CRM <<
                end;
            }
            field("Work Phone No."; Rec."Telex No.")
            {
            }
            field("Family Size"; "Family Size")
            {
            }
            field("Monthly Income bracket"; "Monthly Income bracket")
            {
            }
            field("Age bracket"; "Age bracket")
            {
            }
            field("Check VAT Registration"; IRD)
            {
                Editable = false;
                ExtendedDatatype = URL;
            }
            part(; 33020139)
            {
                SubPageLink = Prospect No.=FIELD(No.);
            }
            part(; 5051)
            {
                SubPageLink = Contact No.=FIELD(No.);
                    Visible = false;
            }
        }
        moveafter("Control 8"; "Control 12")
        moveafter("Control 12"; "Control 14")
        moveafter("Control 20"; "Control 16")
        moveafter(Occupation; Address)
    }
    actions
    {

        //Unsupported feature: Property Insertion (Name) on "Action 1900000003".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 90".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 100".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 96".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 3".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 42".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 95".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 6".


        //Unsupported feature: Property Deletion (Level) on "Action 1900000003".


        //Unsupported feature: Property Deletion (Level) on "Action 1900000006".

        addfirst("Action 76")
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
        addafter("Action 100")
        {
            action("Vehicle Sales Quotes")
            {
                Caption = 'Vehicle Sales Quotes';
                Image = Quote;
                RunObject = Page 25006471;
                                RunPageLink = Sell-to Contact No.=FIELD(No.);
                RunPageView = SORTING(Document Type,Sell-to Contact No.);
            }
            action("<Action1101904001>")
            {
                Caption = 'Spare Parts Sales Quotes';
                Image = Quote;
                RunObject = Page 25006817;
                                RunPageLink = Sell-to Customer No.=FIELD(No.);
                RunPageView = SORTING(Document Type,Sell-to Contact No.);
            }
            action("<Action1101914001>")
            {
                Caption = 'Service Quotes';
                Image = Quote;
                RunObject = Page 25006254;
                                RunPageLink = Sell-to Customer No.=FIELD(No.);
                RunPageView = SORTING(Document Type,Sell-to Contact No.);
            }
        }
        addfirst("Action 75")
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
        addafter("Action 103")
        {
            action("New Sales Quote (Veh)")
            {
                Image = Quote;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page 25006471;
                                RunPageLink = Sell-to Contact No.=FIELD(No.);
                RunPageMode = Create;
            }
            separator()
            {
            }
        }
        addafter("Action 6")
        {
            separator()
            {
            }
        }
        addfirst("Action 1900000006")
        {
            action("Sales Contact Reminder")
            {
                RunObject = Report 33020016;
            }
        }
        addfirst(creation)
        {
            action("Sales Satisfaction Index")
            {
                Image = GetEntries;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page 33020196;
                                RunPageLink = Prospect No.=FIELD(No.);
                Visible = false;
            }
            separator()
            {
            }
            action("Sales Progress")
            {
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page 33020157;
                                RunPageLink = Field1=FIELD(No.);
                Visible = false;
            }
            action("Model Interested In")
            {
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page 33020152;
                                RunPageLink = Prospect No.=FIELD(No.);
                Visible = false;
            }
            action("Source of Inquiry")
            {
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page 33020156;
                                RunPageLink = Prospect No.=FIELD(No.);
                Visible = false;
            }
            action("Timeline for purchase")
            {
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page 33020155;
                                RunPageLink = Prospect No.=FIELD(No.);
                Visible = false;
            }
            action("Next Appointment")
            {
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page 33020153;
                                RunPageLink = Prospect No.=FIELD(No.);
                Visible = false;
            }
            action("Save Contact for Vehicle")
            {
                Promoted = true;
                PromotedCategory = Category4;
                Visible = false;

                trigger OnAction()
                begin
                    BEGIN
                      TESTFIELD("Contact Creation Completed",FALSE) ;
                      IF "Vehicle Contact" THEN BEGIN
                      TESTFIELD("Salesperson Code");
                      TESTFIELD(Name);
                      TESTFIELD(Address);
                      TESTFIELD("Mobile Phone No.");
                      recProspectVehInfo.SETRANGE(recProspectVehInfo."Prospect No.","No.");
                      IF recProspectVehInfo.FINDFIRST THEN
                      recProspectVehInfo.TESTFIELD(recProspectVehInfo."Model Version No.")
                      ELSE
                      ERROR('Model interested in must have a value for the contact '+"No.");
                      "Contact Creation Completed":=TRUE;
                      MESSAGE('Contact No '+ "No."+' has been saved');
                      END;
                    END;
                end;
            }
            action("<Action1000000000>")
            {
                Caption = 'GatePass';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CreateGatePass;
                end;
            }
        }
    }


    //Unsupported feature: Property Modification (Id) on "CRMIntegrationEnabled(Variable 1006)".

    //var
        //>>>> ORIGINAL VALUE:
        //CRMIntegrationEnabled : 1006;
        //Variable type has not been exported.
        //>>>> MODIFIED VALUE:
        //CRMIntegrationEnabled : 10061;
        //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "CRMIsCoupledToRecord(Variable 1007)".

    //var
        //>>>> ORIGINAL VALUE:
        //CRMIsCoupledToRecord : 1007;
        //Variable type has not been exported.
        //>>>> MODIFIED VALUE:
        //CRMIsCoupledToRecord : 10071;
        //Variable type has not been exported.

    var
        SalesHeader: Record "36";

    var
        SalesQuotes: Page "9300";

    var
        PipelineHistory: Record "33020198";
        gblUserSetup: Record "91";
        recProspectVehInfo: Record "33020151";
        IRD: Text;
        gblProspect: Record "5050";
        gblProsPipeHsty: Record "33020198";
        gblCRMMngt: Codeunit "33020142";
        gblRestrictedProspectType: Boolean;
        C2SStage_G: Record "33020152";
        PipeLineDetails_G: Record "33020141";
        UserSetup_G: Record "91";
        SalesPerson_G: Record "13";
        DivisionType: Option " ",CVD,PCD;
        CRMMasterTemplate: Record "33020143";
        CustomerTypePage: Page "33020146";


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //begin
    /*
    IRD := 'https://ird.gov.np/PanSearch?pan='+"VAT Registration No.";
    */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IsOfficeAddin := OfficeManagement.IsAvailable;
    CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IsOfficeAddin := OfficeManagement.IsAvailable;
    CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    // CNY.CRM >>
      IF UserSetup_G.GET(USERID) THEN BEGIN
        IF SalesPerson_G.GET(UserSetup_G."Salespers./Purch. Code") THEN
          DivisionType := SalesPerson_G."Vehicle Division";
      END;
    // CNY.CRM <<
    */
    //end;

    procedure CreateGatePass()
    var
        GatepassHeader: Record "50004";
        GatepassLine: Record "50005";
        GatepassPage: Page "50002";
        Text000: Label 'Document cannot be identified for gatepass. Please issue Gatepass Manually.';
        Customer: Record "18";
        PipelineMgt: Record "33020141";
    begin
        GatepassHeader.RESET;
        GatepassHeader.SETCURRENTKEY("External Document No.");
        GatepassHeader.SETRANGE("External Document No.", "No.");
        IF NOT GatepassHeader.FINDFIRST THEN BEGIN
            GatepassHeader.INIT;

            GatepassHeader."Document Type" := GatepassHeader."Document Type"::"Vehicle Trade";
            GatepassHeader."External Document Type" := GatepassHeader."External Document Type"::"Vehicle Trial";
            GatepassHeader."External Document No." := "No.";
            GatepassHeader.Person := Rec.Name;
            GatepassHeader.Owner := Rec.Name;
            GatepassHeader.Destination := 'Out';
            PipelineMgt.RESET;
            PipelineMgt.SETRANGE("Prospect No.", "No.");
            IF PipelineMgt.FINDFIRST THEN
                GatepassHeader."Vehicle Registration No." := PipelineMgt."Model Version No.";

            GatepassHeader.VALIDATE("Issued Date", TODAY);
            GatepassHeader.INSERT(TRUE);
        END;
        GatepassPage.SETRECORD(GatepassHeader);
        GatepassPage.RUN;
    end;
}

