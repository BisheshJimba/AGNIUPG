table 33020512 "Posted Salary Header"
{
    // *PAYROLL 6.1.0 YURAN@AGILE*


    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "From Date"; Date)
        {
        }
        field(3; "To Date"; Date)
        {
        }
        field(4; Month; Option)
        {
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(5; Remarks; Text[50])
        {
        }
        field(6; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1));
        }
        field(7; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));
        }
        field(8; "Bank Code"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(9; "Bank Name"; Text[50])
        {
            CalcFormula = Lookup("Bank Account".Name WHERE(No.=FIELD(Bank Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(10;"Responsibility Center";Code[10])
        {
            TableRelation = "Responsibility Center";
        }
        field(11;"Pre-Assigned No. Series";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(12;"Document Date";Date)
        {
        }
        field(13;"Posting Date";Date)
        {
        }
        field(22;"No. Series";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(23;"Posting Description";Text[50])
        {
        }
        field(24;"Assigned User ID";Code[50])
        {
            TableRelation = "User Setup";
        }
        field(25;"Journal Template Name";Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(26;"Journal Batch Name";Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Journal Template Name));
        }
        field(27;"Irregular Process";Boolean)
        {
        }
        field(28;"From Date (B.S)";Code[10])
        {
        }
        field(29;"To Date (B.S)";Code[10])
        {
        }
        field(30;"Nepali Month";Option)
        {
            OptionCaption = ' ,Baisakh,Jestha,Asar,Shrawan,Bhadra,Ashoj,Kartik,Mangsir,Poush,Margh,Falgun,Chaitra';
            OptionMembers = " ",Baisakh,Jestha,Asar,Shrawan,Bhadra,Ashoj,Kartik,Mangsir,Poush,Margh,Falgun,Chaitra;
        }
        field(50;"Source Code";Code[10])
        {
            TableRelation = "Source Code";
        }
        field(51;"Pre-Assigned No.";Code[20])
        {
        }
        field(52;"User ID";Code[50])
        {
            TableRelation = Table2000000002;
        }
        field(53;"No. Printed";Integer)
        {
        }
        field(54;Reversed;Boolean)
        {
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(481;"Employee Filter";Code[20])
        {
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        NoSeriesMngt: Codeunit "396";
        PRSetup: Record "33020507";

    [Scope('Internal')]
    procedure AssistEdit(xEmpSalaryHeader: Record "33020510"): Boolean
    begin
        PRSetup.GET;
        TestNoSeries;
        IF NoSeriesMngt.SelectSeries(GetNoSeries,xEmpSalaryHeader."No. Series","Pre-Assigned No. Series") THEN BEGIN
          PRSetup.GET;
          TestNoSeries;
          NoSeriesMngt.SetSeries("No.");
          EXIT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure TestNoSeries(): Boolean
    begin
        PRSetup.TESTFIELD("Salary Plan No. Series");
    end;

    [Scope('Internal')]
    procedure GetNoSeries(): Code[20]
    begin
        EXIT(PRSetup."Salary Plan No. Series");
    end;

    [Scope('Internal')]
    procedure Navigate()
    var
        NavigateForm: Page "344";
    begin
        NavigateForm.SetDoc("Posting Date","No.");
        NavigateForm.RUN;
    end;
}

