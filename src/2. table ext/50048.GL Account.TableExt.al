tableextension 50048 tableextension50048 extends "G/L Account"
{
    // 08.06.2007. EDMS P2
    //   * Added new field Description
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 12)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Balance at Date"(Field 31)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Net Change"(Field 32)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Budgeted Amount"(Field 33)".


        //Unsupported feature: Property Modification (CalcFormula) on "Balance(Field 36)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Budget at Date"(Field 37)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Debit Amount"(Field 47)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Credit Amount"(Field 48)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Budgeted Debit Amount"(Field 52)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Budgeted Credit Amount"(Field 53)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Additional-Currency Net Change"(Field 60)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Add.-Currency Balance at Date"(Field 61)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Additional-Currency Balance"(Field 62)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Add.-Currency Debit Amount"(Field 64)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Add.-Currency Credit Amount"(Field 65)".

        field(50000; "Document Class Mandatory"; Boolean)
        {

            trigger OnValidate()
            begin
                IF NOT "Document Class Mandatory" AND ("Document Class" <> "Document Class"::" ") THEN //chandra 09 Jan 2015
                    ERROR(Text50001);

                IF "Document Class Mandatory"
                THEN
                    MESSAGE(Text50000);
            end;
        }
        field(50001; "Document Class"; Option)
        {
            Caption = 'Document Class';
            OptionCaption = ' ,Customer,Vendor,Bank Account';
            OptionMembers = " ",Customer,Vendor,"Bank Account";

            trigger OnValidate()
            begin
                TESTFIELD("Document Class Mandatory"); //chandra 09 Jan 2015
            end;
        }
        field(50002; "Is Insurance Charge"; Boolean)
        {
        }
        field(50003; "Is Freight Charge"; Boolean)
        {
        }
        field(50050; "LC No Mandatory"; Option)
        {
            Caption = 'LC No Mandatory';
            OptionCaption = ' ,Purchase LC,Sales LC';
            OptionMembers = " ","Purchase LC","Sales LC";
        }
        field(50055; "Commercial Invoice Mandatory"; Boolean)
        {
        }
        field(50056; "Description VAT Book"; Text[50])
        {
        }
        field(51030; "Intransit Filter"; Boolean)
        {
            FieldClass = FlowFilter;
        }
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006052; "Veh. Cost Closing Entry Filter"; Boolean)
        {
            Caption = 'Veh. Cost Closing Entry Filter';
            Description = 'Vehicle Cost Support';
            FieldClass = FlowFilter;
        }
        field(25006055; "Vehicle Serial No. Filter"; Code[20])
        {
            Caption = 'Vehicle Serial No. Filter';
            FieldClass = FlowFilter;
            TableRelation = Vehicle."Serial No.";
        }
        field(25006060; "Vehicle ID Mandatory"; Boolean)
        {
            Caption = 'Vehicle ID Mandatory';
        }
        field(25006379; "Vehicle Acc. Cycle No. Filter"; Code[20])
        {
            Caption = 'Vehicle Acc. Cycle No. Filter';
            FieldClass = FlowFilter;
            TableRelation = "Vehicle Accounting Cycle"."No.";
        }
        field(25006390; Description; Text[150])
        {
            Caption = 'Description';
        }
        field(25006400; "Source Type Filter"; Option)
        {
            Caption = 'Source Type Filter';
            FieldClass = FlowFilter;
            OptionCaption = ' ,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(25006410; "Source No. Filter"; Code[20])
        {
            Caption = 'Source No. Filter';
            FieldClass = FlowFilter;
            TableRelation = IF ("Source Type Filter" = CONST(Customer)) Customer."No."
            ELSE IF ("Source Type Filter" = CONST(Vendor)) Vendor."No."
            ELSE IF ("Source Type Filter" = CONST("Bank Account")) "Bank Account"."No.";

            trigger OnLookup()
            var
                Customer: Record Customer;
                Vendor: Record Vendor;
                FixedAsset: Record "Fixed Asset";
                BankAccount: Record "Bank Account";
            begin
                CASE "Source Type Filter" OF
                    "Source Type Filter"::Customer:
                        IF PAGE.RUNMODAL(PAGE::"Customer List", Customer) = ACTION::LookupOK THEN
                            VALIDATE("Source No. Filter", Customer."No.");
                    "Source Type Filter"::Vendor:
                        IF PAGE.RUNMODAL(PAGE::"Vendor List", Vendor) = ACTION::LookupOK THEN
                            VALIDATE("Source No. Filter", Vendor."No.");
                    "Source Type Filter"::"Bank Account":
                        IF PAGE.RUNMODAL(PAGE::"Bank Account List", BankAccount) = ACTION::LookupOK THEN
                            VALIDATE("Source No. Filter", BankAccount."No.");
                    "Source Type Filter"::"Fixed Asset":
                        IF PAGE.RUNMODAL(PAGE::"Fixed Asset List", FixedAsset) = ACTION::LookupOK THEN
                            VALIDATE("Source No. Filter", FixedAsset."No.");
                END;
            end;
        }
        field(33020500; "Link to Register Type"; Option)
        {
            OptionCaption = ' ,Advance,Loan,Insurance,Letter of Credit,TDS';
            OptionMembers = " ",Advance,Loan,Insurance,"Letter of Credit",TDS;
        }
        field(33020501; "Source Code Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Source Code".Code;
        }
    }
    keys
    {
        key(Key1; "Document Class")
        {
        }
    }

    //Unsupported feature: Property Modification (Fields) on "DropDown(FieldGroup 1)".


    var
        Text50000: Label 'Please select Vendor, Customer or Bank in Document Class if GL Account is to be particularly linked to those Class. Otherwise Leave blank.';
        Text50001: Label 'Document Class must be blank';
}

