table 33019823 "Vehicles With Flowfield"
{

    fields
    {
        field(1; "Serial No."; Code[20])
        {
        }
        field(8; VIN; Code[20])
        {
            Caption = 'VIN';
            NotBlank = true;

            trigger OnValidate()
            begin
                /*CheckDublicates; //Checking for dublicates
                
                // mar 25, 2015 ZM
                {
                "Make Code" := '';
                "Model Code" := '';
                "Model Version No." := '';
                "Variable Field 25006808" := '';
                }
                VINDecode.Decode2(Rec);
                VehChangeLogMgt.fRegisterChange(Rec,xRec,FIELDNO(VIN));
                
                //SM Agni
                VIN := DELCHR(VIN,'=','-\/!|@|#|$|%_)(^*&');
                VIN := DELCHR(VIN,'=',' ');
                //SM Agni
                */

            end;
        }
        field(10; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            NotBlank = true;
            TableRelation = Make;

            trigger OnValidate()
            begin
                //28.02.2008. EDMS P2 >>
                /*IF "Make Code" <> xRec."Make Code" THEN
                  VALIDATE("Model Code", '');
                //28.02.2008. EDMS P2 >>
                
                 CheckSerialNoInItemLedgerEntry(FIELDCAPTION("Make Code")); // mar 25, 2015 ZM
                 */

            end;
        }
        field(20; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make Code));

            trigger OnValidate()
            begin
                //28.02.2008. EDMS P2 >>
                /*IF "Model Code" <> xRec."Model Code" THEN
                  VALIDATE("Model Version No.", '');
                //28.02.2008. EDMS P2 >>
                
                 CheckSerialNoInItemLedgerEntry(FIELDCAPTION("Model Code"));  // mar 25, 2015 ZM
                 */

            end;
        }
        field(25;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item.No. WHERE (Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code),
                                            Item Type=CONST(Model Version));

            trigger OnLookup()
            var
                recItem: Record "27";
            begin
            end;
        }
        field(670;Inventory;Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE (Serial No.=FIELD(Serial No.)));
            Caption = 'Inventory';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50000;"Custom Clearance Memo No.";Code[20])
        {
            CalcFormula = Lookup("CC Memo Line"."Reference No." WHERE (Chasis No.=FIELD(VIN)));
            Description = 'ff';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "CC Memo Header"."Reference No.";
        }
        field(50001;"Insurance Memo No.";Code[20])
        {
            CalcFormula = Max("Ins. Memo Line"."Reference No." WHERE (Vehicle Serial No.=FIELD(Serial No.)));
            Description = 'ff';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003;"Insurance Policy No.";Code[50])
        {
            CalcFormula = Max("Vehicle Insurance"."Insurance Policy No." WHERE (Vehicle Serial No.=FIELD(UPPERLIMIT(Serial No.)),
                                                                                Cancelled=CONST(No)));
            Description = 'ff';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004;"Item Charges Applied";Boolean)
        {
            CalcFormula = Exist("Value Entry" WHERE (Item No.=FIELD(Model Version No.),
                                                     Item Charge No.=FILTER(<>'')));
            Description = 'ff';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005;"Sales Invoice No.";Code[20])
        {
            CalcFormula = Max("Sales Invoice Line"."Document No." WHERE (Vehicle Serial No.=FIELD(UPPERLIMIT(Serial No.))));
            Description = 'ff';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            var
                SalesInvHeader: Record "112";
            begin
                SalesInvHeader.RESET;
                //uSalesInvHeader.SETRANGE("No.","Sales Invoice No.");
                IF SalesInvHeader.FINDFIRST THEN
                  PAGE.RUNMODAL(PAGE::"Posted Sales Invoice",SalesInvHeader);
            end;
        }
        field(50006;"Purchase Receipt Date";Date)
        {
            CalcFormula = Max("Item Ledger Entry"."Posting Date" WHERE (Serial No.=FIELD(Serial No.),
                                                                        Document Type=CONST(Purchase Receipt)));
            Description = 'Used to Calculate vehicle aging from the purchase receipt date in case of transfer//chandra (jet reports) ff';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007;"Purchase Order Date";Date)
        {
            CalcFormula = Lookup("Item Ledger Entry"."Document Date" WHERE (Serial No.=FIELD(Serial No.),
                                                                            Document Type=CONST(Purchase Receipt)));
            Description = 'ff';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50008;"Ins. Payment Memo No.";Code[20])
        {
            CalcFormula = Max("Ins. Payment Memo Line".No. WHERE (Vehicle Serial No.=FIELD(Serial No.)));
            Description = 'ff';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50050;"Purchase Invoice";Code[20])
        {
            CalcFormula = Max("Purch. Inv. Line"."Document No." WHERE (Vehicle Serial No.=FIELD(Serial No.)));
            Description = 'ff';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50051;"Purchase Invoice Date";Date)
        {
            CalcFormula = Lookup("Purch. Inv. Line"."Posting Date" WHERE (Vehicle Serial No.=FIELD(Serial No.)));
            Description = 'ff';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50052;"Purchase Invoice Date (Real)";Date)
        {
            Description = 'ff';
        }
        field(25006379;"Default Vehicle Acc. Cycle No.";Code[20])
        {
            CalcFormula = Lookup("Vehicle Accounting Cycle".No. WHERE (Vehicle Serial No.=FIELD(Serial No.),
                                                                       Default=CONST(Yes)));
            Caption = 'Default Vehicle Acc. Cycle No.';
            Description = 'ff';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Vehicle Accounting Cycle";
        }
        field(33020025;"Total Commission Paid";Decimal)
        {
            CalcFormula = -Sum("G/L Entry".Amount WHERE (Document Class=CONST(Vendor),
                                                         G/L Account No.=CONST(205102),
                                                         Vehicle Serial No.=FIELD(Serial No.)));
            Description = 'ff';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020264;"Scheme Code";Code[20])
        {
            Description = 'ff  put this back';
            Editable = false;
        }
        field(33020265;"Scheme Type";Option)
        {
            Description = 'ff put this back';
            Editable = false;
            OptionCaption = ' ,Primary,Secondary';
            OptionMembers = " ",Primary,Secondary;
        }
        field(33020501;"Current Location of Vehicle";Code[10])
        {
            CalcFormula = Lookup("Item Ledger Entry"."Location Code" WHERE (Serial No.=FIELD(Serial No.),
                                                                            Remaining Quantity=CONST(1),
                                                                            Open=CONST(Yes)));
            Description = 'Temporary Fix to know VIN Location before Sales as 33020014 field not working properly//chandra';
            FieldClass = FlowField;
        }
        field(33020508;"PDI Status";Option)
        {
            CalcFormula = Lookup("PDI Header".Status WHERE (VIN=FIELD(VIN)));
            Caption = 'PDI Status';
            Description = 'ff';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'Open,Closed';
            OptionMembers = Open,Closed;
        }
        field(33020509;"PDI Type";Option)
        {
            CalcFormula = Lookup("PDI Header"."PDI Type" WHERE (VIN=FIELD(VIN)));
            Description = 'ff';
            FieldClass = FlowField;
            OptionMembers = ,"Regular PDI","Accidental Repair";
        }
        field(33020510;"Variant Code";Code[20])
        {
            CalcFormula = Max("Item Ledger Entry"."Variant Code" WHERE (Serial No.=FIELD(Serial No.)));
            Description = 'Temporary Fix to know Variant Code as 33020019 field not working properly//chandra';
            FieldClass = FlowField;
        }
        field(33020511;"Next Service Date";Date)
        {
            CalcFormula = Max("Posted Serv. Order Header"."Next Service Date" WHERE (Vehicle Serial No.=FIELD(Serial No.)));
            Description = 'ff';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020512;"Kilometrage SR";Decimal)
        {
            CalcFormula = Max("Posted Serv. Order Header".Kilometrage WHERE (Vehicle Serial No.=FIELD(Serial No.)));
            Description = 'ff';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020526;"Has Invoice";Boolean)
        {
            CalcFormula = Exist("Sales Invoice Header" WHERE (Vehicle Serial No.=FIELD(Serial No.)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Serial No.")
        {
            Clustered = true;
        }
        key(Key2;VIN,"Make Code","Model Code","Model Version No.")
        {
        }
    }

    fieldgroups
    {
    }
}

