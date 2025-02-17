table 33020200 "Salesperson KAP Details"
{

    fields
    {
        field(1; "Salesperson Code"; Code[10])
        {
            Editable = false;
        }
        field(2; Year; Integer)
        {
            Editable = false;
        }
        field(3; Month; Option)
        {
            Editable = false;
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(4; "Area"; Code[10])
        {
            Editable = false;
            TableRelation = Area.Code;
        }
        field(5; Make; Code[20])
        {
            TableRelation = Make;
        }
        field(6; "Model No."; Code[20])
        {
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make));
        }
        field(7;"Model Version No.";Code[20])
        {
            TableRelation = Item.No. WHERE (Item Type=CONST(Model Version),
                                            Make Code=FIELD(Make),
                                            Model Code=FIELD(Model No.));

            trigger OnLookup()
            begin
                //Lookup Model Version.
                GblItem.RESET;
                IF GblLookupMgt.LookUpModelVersion(GblItem,"Model Version No.",Make,"Model No.") THEN
                 VALIDATE("Model Version No.",GblItem."No.");
            end;

            trigger OnValidate()
            begin
                //Code to bring model version name.
                GblItem.RESET;
                GblItem.SETRANGE("No.","Model Version No.");
                IF GblItem.FIND('-') THEN
                  "Model Version Name" := GblItem.Description;
            end;
        }
        field(8;"Model Version Name";Text[50])
        {
        }
        field(10;"Target C0";Integer)
        {
        }
        field(11;"Target C1";Integer)
        {
        }
        field(12;"Target C2";Integer)
        {
        }
        field(13;"Target C3";Integer)
        {
        }
        field(14;"By When";Date)
        {
        }
        field(15;"Strategy (Monitorable Param)";Text[250])
        {
            Caption = 'Strategy (Monitorable Parameters)';
        }
        field(17;"Line No.";Integer)
        {
            AutoIncrement = true;
        }
        field(18;"Achieved C0";Integer)
        {
            CalcFormula = Count("Prospect Pipeline History" WHERE (New Pipeline Code=CONST(C0),
                                                                   SalesPerson Code=FIELD(Salesperson Code),
                                                                   KIN=FIELD(KIN)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(19;"Achieved C1";Integer)
        {
            CalcFormula = Count("Prospect Pipeline History" WHERE (New Pipeline Code=CONST(C1),
                                                                   SalesPerson Code=FIELD(Salesperson Code),
                                                                   KIN=FIELD(KIN)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(20;"Achieved C2";Integer)
        {
            CalcFormula = Count("Prospect Pipeline History" WHERE (New Pipeline Code=CONST(C2),
                                                                   SalesPerson Code=FIELD(Salesperson Code),
                                                                   KIN=FIELD(KIN)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(21;"Achieved C3";Integer)
        {
            CalcFormula = Count("Prospect Pipeline History" WHERE (New Pipeline Code=CONST(C3),
                                                                   SalesPerson Code=FIELD(Salesperson Code),
                                                                   KIN=FIELD(KIN)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(22;"RS of Activity";Text[250])
        {
            Caption = 'Remarks and Status of Activity';
        }
        field(23;"Week No";Integer)
        {
            Editable = false;
        }
        field(25;Activity;Code[10])
        {
            TableRelation = "KAP Master".Activity;

            trigger OnValidate()
            begin
                // CNY.CRM >>

                KapMaster_G.RESET;
                KapMaster_G.SETRANGE(Activity,Activity);
                IF KapMaster_G.FINDFIRST THEN
                  "What to do" := KapMaster_G.Description;

                // CNY.CRM <<
            end;
        }
        field(26;"What to do";Text[150])
        {
            Editable = false;
        }
        field(27;"Target Activities";Decimal)
        {
        }
        field(28;"Achieved Activities";Decimal)
        {
        }
        field(33;KIN;Code[20])
        {
            Editable = false;
        }
        field(35;"KAP Status";Option)
        {
            Editable = false;
            OptionCaption = ' ,Done,Postponed,Not Done';
            OptionMembers = " ",Done,Postponed,"Not Done";
        }
        field(50;Status;Option)
        {
            Editable = false;
            OptionCaption = 'Open,Released';
            OptionMembers = Open,Released;
        }
    }

    keys
    {
        key(Key1;"Salesperson Code",Year,Month,"Week No",KIN)
        {
            Clustered = true;
        }
        key(Key2;"Salesperson Code",Year,Month,"Week No","KAP Status")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD(Status,Status :: Open); // CNY.CRM
    end;

    trigger OnInsert()
    begin
        // CNY.CRM >>
        KIN := NoseriesMgt.GetNextNo('KIN',TODAY,TRUE);

        IF UserSetup_G.GET(USERID) THEN BEGIN
           IF SalesPerson_G.GET(UserSetup_G."Salespers./Purch. Code") THEN
            IF SalesPerson_G."Vehicle Division" = SalesPerson_G."Vehicle Division" :: PCD THEN
              Make := 'TATA PCD'
            ELSE IF SalesPerson_G."Vehicle Division" = SalesPerson_G."Vehicle Division" :: CVD THEN
              Make := 'TATA CVD';
        END;
        // CNY.CRM <<
    end;

    trigger OnModify()
    begin
        TESTFIELD(Status,Status :: Open); // CNY.CRM
    end;

    trigger OnRename()
    begin
        TESTFIELD(Status,Status :: Open); // CNY.CRM
    end;

    var
        GblLookupMgt: Codeunit "25006003";
        GblItem: Record "27";
        KapMaster_G: Record "33020144";
        NoseriesMgt: Codeunit "396";
        UserSetup_G: Record "91";
        SalesPerson_G: Record "13";
}

