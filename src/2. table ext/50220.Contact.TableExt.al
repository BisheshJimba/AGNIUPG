tableextension 50220 tableextension50220 extends Contact
{
    // 03.07.2015 EB.P30
    //   Specified Table DrillDownPageID
    // 
    // 28.01.2008 EDMS P3
    //         * SalesPerson on interaction
    // 30-07-2007 EDMS P3 CRM
    //   * New procedures ShowQuickCust & MakeQuickCust, Const Text100 - for fast creation of customer
    // 07-08-2007 EDMS P3
    //   * New field 25006000 - birthday
    // 08-08-2007 EDMS P3
    //   * There was errorneous logic
    // 10-08-2007 EDMS P3
    //   * CheckObligatoryFields - for fields checking
    //   * MakeQuickCust - added return parameter
    fields
    {

        //Unsupported feature: Property Modification (Data type) on "Name(Field 2)".


        //Unsupported feature: Property Modification (Data type) on ""Search Name"(Field 3)".


        //Unsupported feature: Property Modification (Data type) on ""Name 2"(Field 4)".

        modify(Address)
        {

            //Unsupported feature: Property Insertion (NotBlank) on "Address(Field 5)".

            Description = 'F001';
        }
        modify("Address 2")
        {

            //Unsupported feature: Property Insertion (NotBlank) on ""Address 2"(Field 6)".

            Description = 'F001';
        }
        modify(City)
        {
            TableRelation = IF (Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
        }
        modify("Phone No.")
        {
            Description = 'F001';
        }
        modify("Telex No.")
        {
            Description = 'Used as Phone 2 Work Phone';
        }
        modify("Territory Code")
        {
            TableRelation = "Dealer Segment Type";
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 38)".

        modify("Post Code")
        {
            TableRelation = IF (Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Country/Region Code));
        }
        modify(Type)
        {
            OptionCaption = ' ,Company,Person';

            //Unsupported feature: Property Modification (OptionString) on "Type(Field 5050)".

        }

        //Unsupported feature: Property Modification (Data type) on ""Company Name"(Field 5052)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Next To-do Date"(Field 5066)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Last Date Attempted"(Field 5067)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Date of Last Interaction"(Field 5068)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Interactions"(Field 5074)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Cost (LCY)"(Field 5076)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Duration (Min.)"(Field 5077)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Opportunities"(Field 5078)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Estimated Value (LCY)"(Field 5079)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Calcd. Current Value (LCY)"(Field 5080)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Opportunity Entry Exists"(Field 5082)".


        //Unsupported feature: Property Modification (CalcFormula) on ""To-do Entry Exists"(Field 5083)".



        //Unsupported feature: Code Modification on "Name(Field 2).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            NameBreakdown;
            ProcessNameChange;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            Name := UPPERCASE(Name); // CNY.CRM

            NameBreakdown;
            ProcessNameChange;
            */
        //end;


        //Unsupported feature: Code Insertion on ""Name 2"(Field 4)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            "Name 2" := UPPERCASE("Name 2"); // CNY.CRM
            */
        //end;


        //Unsupported feature: Code Insertion on "Address(Field 5)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            Address := UPPERCASE(Address); // CNY.CRM
            */
        //end;


        //Unsupported feature: Code Insertion on ""Address 2"(Field 6)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            "Address 2" := UPPERCASE("Address 2"); // CNY.CRM
            */
        //end;


        //Unsupported feature: Code Modification on "City(Field 7).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            PostCode.ValidateCity(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            City := UPPERCASE(City); // CNY.CRM
            PostCode.ValidateCity(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            */
        //end;


        //Unsupported feature: Code Insertion on ""Phone No."(Field 9)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            "Phone No." := UPPERCASE("Phone No."); // CNY.CRM
            */
        //end;


        //Unsupported feature: Code Insertion on ""Telex No."(Field 10)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            "Telex No." := UPPERCASE("Telex No."); // CNY.CRM
            */
        //end;


        //Unsupported feature: Code Insertion on ""Fax No."(Field 84)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            "Fax No." := UPPERCASE("Fax No."); // CNY.CRM
            */
        //end;


        //Unsupported feature: Code Modification on ""VAT Registration No."(Field 86).OnValidate".

        //trigger "(Field 86)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF VATRegNoFormat.Test("VAT Registration No.","Country/Region Code","No.",DATABASE::Contact) THEN
              IF "VAT Registration No." <> xRec."VAT Registration No." THEN
                VATRegistrationLogMgt.LogContact(Rec);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            "VAT Registration No." := UPPERCASE("VAT Registration No."); // CNY.CRM

            #1..3
            */
        //end;


        //Unsupported feature: Code Insertion on "County(Field 92)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            County := UPPERCASE(County);  // CNY.CRM
            */
        //end;


        //Unsupported feature: Code Modification on ""Company Name"(Field 5052).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            VALIDATE("Company No.",GetCompNo("Company Name"));
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            "Company Name" := UPPERCASE("Company Name"); // CNY.CRM
            VALIDATE("Company No.",GetCompNo("Company Name"));
            */
        //end;


        //Unsupported feature: Code Modification on ""First Name"(Field 5054).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            Name := CalculatedName;
            ProcessNameChange;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            "First Name" := UPPERCASE("First Name"); // CNY.CRM

            Name := CalculatedName;
            ProcessNameChange;
            */
        //end;


        //Unsupported feature: Code Modification on ""Middle Name"(Field 5055).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            Name := CalculatedName;
            ProcessNameChange;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            "Middle Name" := UPPERCASE("Middle Name"); // CNY.CRM

            Name := CalculatedName;
            ProcessNameChange;
            */
        //end;


        //Unsupported feature: Code Insertion on "Surname(Field 5056)".

        //trigger OnLookup(var Text: Text): Boolean
        //begin
            /*
            Surname := UPPERCASE(Surname); // CNY.CRM
            */
        //end;


        //Unsupported feature: Code Insertion on ""Job Title"(Field 5058)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            "Job Title" := UPPERCASE("Job Title"); // CNY.CRM
            */
        //end;


        //Unsupported feature: Code Insertion on "Initials(Field 5059)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            Initials := UPPERCASE(Initials); // CNY.CRM
            */
        //end;


        //Unsupported feature: Code Insertion on ""Extension No."(Field 5060)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            "Extension No." := UPPERCASE("Extension No."); // CNY.CRM
            */
        //end;


        //Unsupported feature: Code Insertion on ""Mobile Phone No."(Field 5061)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            "Mobile Phone No." := UPPERCASE("Mobile Phone No."); // CNY.CRM
            */
        //end;
        field(50001;"Citizenship No.";Code[30])
        {

            trigger OnValidate()
            begin
                // CNY.CRM >>
                // Contact_G.RESET;
                // Contact_G.SETRANGE("Citizenship No.","Citizenship No.");
                // Contact_G.SETRANGE("Citizenship Issued District","Citizenship Issued District");
                // IF Contact_G.FINDFIRST THEN
                //  ERROR('Citizen Ship No. already exists with contact No. %1 ',Contact_G."No.");
                // CNY.CRM <<
            end;
        }
        field(50002;"Citizenship Issued District";Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE (Dimension Code=CONST(DISTRICT));

            trigger OnValidate()
            begin
                // CNY.CRM >>
                // Contact_G.RESET;
                // Contact_G.SETRANGE("Citizenship No.","Citizenship No.");
                // Contact_G.SETRANGE("Citizenship Issued District","Citizenship Issued District");
                // IF Contact_G.FINDFIRST THEN
                //  ERROR('Citizen Ship No. already exists with contact No. %1 ',Contact_G."No.");
                // CNY.CRM <<
            end;
        }
        field(50005;"Contact Person";Code[70])
        {
            Description = 'CNY.CRM';
        }
        field(50006;"Credit Officer Code";Code[20])
        {
            Description = 'SRT (for hire purchase)';
            TableRelation = Salesperson/Purchaser.Code;

            trigger OnValidate()
            begin
                VALIDATE("Salesperson Code","Credit Officer Code"); //SRT jan 31st 2020
            end;
        }
        field(50007;Guarantor;Boolean)
        {
        }
        field(25006000;Birthday;Date)
        {
            Caption = 'Birthday';
        }
        field(25006010;"Last User Modified";Code[50])
        {
            Caption = 'Last User Modified';
            Editable = false;
        }
        field(33019975;"Province No.";Option)
        {
            OptionCaption = ' ,Province 1, Province 2, Bagmati Province, Gandaki Province, Province 5, Karnali Province, Sudur Pachim Province ';
            OptionMembers = " ","Province 1"," Province 2"," Bagmati Province"," Gandaki Province"," Province 5"," Karnali Province"," Sudur Pachim Province";
        }
        field(33020142;Updated;Boolean)
        {
        }
        field(33020143;"Time Logged In";Time)
        {
        }
        field(33020144;"Anniversary Year";Integer)
        {
        }
        field(33020145;"Anniversary Month";Option)
        {
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(33020146;"Anniversary Day";Integer)
        {
        }
        field(33020147;"Birth Year";Integer)
        {
        }
        field(33020148;"Birth Month";Option)
        {
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(33020149;"Birth Day";Integer)
        {
        }
        field(33020150;Status;Option)
        {
            Description = 'Inactive is Lost';
            OptionCaption = 'Active,Inactive';
            OptionMembers = Active,Inactive;
        }
        field(33020153;"Customer Type";Code[10])
        {
        }
        field(33020154;"Created Date";Date)
        {
        }
        field(33020156;Occupation;Code[20])
        {
            Description = 'C0';
            NotBlank = true;
            TableRelation = "Contact Occupation".Occupation;
        }
        field(33020157;"Family Size";Option)
        {
            Description = 'C0';
            NotBlank = true;
            OptionMembers = " ",Two,Three,"Four-Six","Seven- Nine","Ten or more";
        }
        field(33020158;"Monthly Income bracket";Option)
        {
            Description = 'C0';
            NotBlank = true;
            OptionMembers = " ","<30000","30000-50000"," 50000- 100000"," >100000";
        }
        field(33020159;"Age bracket";Option)
        {
            Description = 'F001';
            NotBlank = true;
            OptionMembers = " ","18-25 years"," 26-35 years"," 36-45 years"," 46-60 years"," 60 and above";
        }
        field(33020160;"Vehicle required";Boolean)
        {
            Description = 'F001';
            NotBlank = true;
        }
        field(33020163;"Vehicle Contact";Boolean)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Contact Creation Completed",FALSE);
            end;
        }
        field(33020164;"Contact Creation Completed";Boolean)
        {
            Editable = false;
        }
        field(33020165;"Model Interested In";Code[20])
        {
        }
    }


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        Todo.SETCURRENTKEY("Contact Company No.","Contact No.",Closed,Date);
        Todo.SETRANGE("Contact Company No.","Company No.");
        Todo.SETRANGE("Contact No.","No.");
        #4..107
        ContAltAddrDateRange.DELETEALL;

        VATRegistrationLogMgt.DeleteContactLog(Rec);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..110

        // CNY.CRM >>
        gblProsPipeHsty.RESET;
        gblProsPipeHsty.SETRANGE("Prospect No.","No.");
        gblProsPipeHsty.DELETEALL;
        // CNY.CRM <<
        */
    //end;


    //Unsupported feature: Code Insertion (VariableCollection) on "OnInsert".

    //trigger (Variable: recSalesPerson)()
    //Parameters and return type have not been exported.
    //begin
        /*
        */
    //end;


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        RMSetup.GET;

        IF "No." = '' THEN BEGIN
          RMSetup.TESTFIELD("Contact Nos.");
          NoSeriesMgt.InitSeries(RMSetup."Contact Nos.",xRec."No. Series",0D,"No.","No. Series");
        END;

        IF NOT SkipDefaults THEN BEGIN
          IF "Salesperson Code" = '' THEN
        #10..23
        END;

        TypeChange;
        SetLastDateTimeModified;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..6
        //--------@yuran 19-jul-2013 Syncs No. Series in all companies>>
        //AgniMgt.SyncMasterData(DATABASE::Contact,"No.","No. Series");
        //--------@yuran 19-jul-2013 Syncs No. Series in all companies<<
        #7..26

        //Sangam on 29 April 2012.
        gblUserSetup.GET(USERID);
        "Salesperson Code" := gblUserSetup."Salespers./Purch. Code";
        SetLastDateTimeModified;
        "Last User Modified" := USERID; //24.10.2007 EDMS P3
        "Created Date" := TODAY;

        IF recSalesPerson.GET(gblUserSetup."Salespers./Purch. Code")  THEN
           IF recSalesPerson."SP for Vehicle" THEN
              VALIDATE("Vehicle Contact",TRUE);
        */
    //end;


    //Unsupported feature: Code Modification on "OnModify(PROCEDURE 4)".

    //procedure OnModify();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SetLastDateTimeModified;

        IF (Type = Type::Company) AND ("No." <> '') THEN BEGIN
          IF (Name <> xRec.Name) OR
             ("Search Name" <> xRec."Search Name") OR
        #6..142
          THEN
            CheckDupl;
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        SetLastDateTimeModified;
        "Last User Modified" := USERID; //24.10.2007 EDMS P3
        Updated := TRUE;
        #3..145
        */
    //end;

    //Unsupported feature: Variable Insertion (Variable: Vehicle) (VariableCollection) on "TypeChange(PROCEDURE 1)".


    //Unsupported feature: Variable Insertion (Variable: VehicleContact) (VariableCollection) on "TypeChange(PROCEDURE 1)".



    //Unsupported feature: Code Modification on "CreateCustomer(PROCEDURE 3)".

    //procedure CreateCustomer();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CheckForExistingRelationships(ContBusRel."Link to Table"::Customer);
        TESTFIELD("Company No.");
        RMSetup.GET;
        RMSetup.TESTFIELD("Bus. Rel. Code for Customers");

        #6..36
        Cust.MODIFY;

        IF CustTemplate.Code <> '' THEN BEGIN
          Cust."Territory Code" := CustTemplate."Territory Code";
          Cust."Currency Code" := CustTemplate."Currency Code";
          Cust."Country/Region Code" := CustTemplate."Country/Region Code";
          Cust."Customer Posting Group" := CustTemplate."Customer Posting Group";
        #44..50
          Cust."Payment Terms Code" := CustTemplate."Payment Terms Code";
          Cust."Payment Method Code" := CustTemplate."Payment Method Code";
          Cust."Shipment Method Code" := CustTemplate."Shipment Method Code";
          Cust.MODIFY;

          DefaultDim.SETRANGE("Table ID",DATABASE::"Customer Template");
        #57..74
        ELSE
          IF NOT HideValidationDialog THEN
            MESSAGE(Text009,Cust.TABLECAPTION,Cust."No.");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        CheckForExistingRelationships(ContBusRel."Link to Table"::Customer);
        //TESTFIELD("Company No.");
        #3..39
          Cust."Dealer Segment Type" := CustTemplate."Territory Code";
        #41..53
          Cust."Citizenship No." := "Citizenship No.";
        #54..77
        */
    //end;

    //Unsupported feature: Variable Insertion (Variable: UserSetup) (VariableCollection) on "CreateInteraction(PROCEDURE 10)".


    //Unsupported feature: Variable Insertion (Variable: PurchSlsPer) (VariableCollection) on "CreateInteraction(PROCEDURE 10)".



    //Unsupported feature: Code Modification on "ChooseCustomerTemplate(PROCEDURE 27)".

    //procedure ChooseCustomerTemplate();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CheckForExistingRelationships(ContBusRel."Link to Table"::Customer);
        ContBusRel.RESET;
        ContBusRel.SETRANGE("Contact No.","No.");
        ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
        IF ContBusRel.FINDFIRST THEN
          ERROR(
            Text019,
            TABLECAPTION,"No.",ContBusRel.TABLECAPTION,ContBusRel."Link to Table",ContBusRel."No.");

        IF CONFIRM(Text020,TRUE,"No.",Name) THEN BEGIN
          IF PAGE.RUNMODAL(0,CustTemplate) = ACTION::LookupOK THEN
            EXIT(CustTemplate.Code);

          ERROR(Text022);
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..7
            TABLECAPTION,"No.",ContBusRel.TABLECAPTION,ContBusRel."Link to Table",ContBusRel."No.")

        ELSE
        //BEGIN  //08-08-2007 EDMS P3 >>
        #10..14
        END   //08-08-2007 EDMS P3  <<
        */
    //end;

    //Unsupported feature: Variable Insertion (Variable: ServiceHeader) (VariableCollection) on "UpdateQuotes(PROCEDURE 29)".


    //Unsupported feature: Variable Insertion (Variable: ServiceLine) (VariableCollection) on "UpdateQuotes(PROCEDURE 29)".


    //Unsupported feature: Variable Insertion (Variable: Vehicle) (VariableCollection) on "UpdateQuotes(PROCEDURE 29)".



    //Unsupported feature: Code Modification on "UpdateQuotes(PROCEDURE 29)".

    //procedure UpdateQuotes();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        Cont.SETCURRENTKEY("Company No.");
        Cont.SETRANGE("Company No.","Company No.");

        #4..32
                IF SalesLine.FINDFIRST THEN
                  SalesLine.MODIFYALL("Bill-to Customer No.",SalesHeader."Bill-to Customer No.");
              UNTIL SalesHeader.NEXT = 0;
          UNTIL Cont.NEXT = 0;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..35

            //EDMS P3 >>
            ServiceHeader.RESET;
            ServiceHeader.SETCURRENTKEY("Document Type","Sell-to Contact No.");
            ServiceHeader.SETRANGE("Document Type",ServiceHeader."Document Type"::Quote);
            ServiceHeader.SETRANGE("Sell-to Contact No.",Cont."No.");
            IF ServiceHeader.FIND('-') THEN
              REPEAT
                ServiceHeader."Sell-to Customer No." := Customer."No.";
                ServiceHeader."Sell-to Customer Template Code" := '';
                ServiceHeader.MODIFY;
                ServiceLine.SETRANGE("Document Type",ServiceHeader."Document Type");
                ServiceLine.SETRANGE("Document No.",ServiceHeader."No.");
                IF ServiceLine.FIND('-') THEN
                  ServiceLine.MODIFYALL("Sell-to Customer No.",ServiceHeader."Sell-to Customer No.");
              UNTIL ServiceHeader.NEXT = 0;

            ServiceHeader.RESET;
            ServiceHeader.SETCURRENTKEY("Bill-to Contact No.");
            ServiceHeader.SETRANGE("Document Type",ServiceHeader."Document Type"::Quote);
            ServiceHeader.SETRANGE("Bill-to Contact No.",Cont."No.");
            IF ServiceHeader.FIND('-') THEN
              REPEAT
                ServiceHeader."Bill-to Customer No." := Customer."No.";
                ServiceHeader."Bill-to Customer Template Code" := '';
                ServiceHeader.MODIFY;
                ServiceLine.SETRANGE("Document Type",ServiceHeader."Document Type");
                ServiceLine.SETRANGE("Document No.",ServiceHeader."No.");
                IF ServiceLine.FIND('-') THEN
                  ServiceLine.MODIFYALL("Bill-to Customer No.",ServiceHeader."Bill-to Customer No.");
              UNTIL ServiceHeader.NEXT = 0;

            //EDMS P3 <<

          UNTIL Cont.NEXT = 0;
        */
    //end;

    procedure ShowQuickCust()
    var
        FormSelected: Boolean;
        Cust: Record "18";
    begin
        FormSelected := TRUE;

        ContBusRel.RESET;
        ContBusRel.SETRANGE("Contact No.","Company No.");
        ContBusRel.SETFILTER("No.",'<>''''');
        ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);

        CASE ContBusRel.COUNT OF
          0: FormSelected := MakeQuickCust;  //08-08-2007 EDMS P3
          1: ContBusRel.FINDFIRST;
          ELSE
            FormSelected := PAGE.RUNMODAL(PAGE::"Contact Business Relations",ContBusRel) = ACTION::LookupOK;
        END;

        IF FormSelected THEN BEGIN
            Cust.GET(ContBusRel."No.");
              PAGE.RUN(PAGE::"Customer Card",Cust);
        END
    end;

    procedure MakeQuickCust(): Boolean
    var
        Selection: Integer;
    begin
        Selection := STRMENU(Text100,1);

        CASE Selection OF
          0: EXIT(FALSE);  //08-08-2007 EDMS P3
          1: CreateCustomerLink;
          2: CreateCustomer(ChooseCustomerTemplate);
        END;
        EXIT(TRUE) //08-08-2007 EDMS P3
    end;

    //Unsupported feature: Property Modification (Fields) on "DropDown(FieldGroup 1)".


    var
        recSalesPerson: Record "13";

    var
        Text100: Label 'Link with existing Customer,Create as Customer';
        gblUserSetup: Record "91";
        PipelineHistory: Record "33020198";
        AgniMgt: Codeunit "50000";
        "------CNY.CRM-----------------": Integer;
        gblProsPipeHsty: Record "33020198";
        Contact_G: Record "5050";
}

