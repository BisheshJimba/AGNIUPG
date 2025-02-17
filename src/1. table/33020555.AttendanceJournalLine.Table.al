table 33020555 "Attendance Journal Line"
{

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            TableRelation = "Attendance Journal Template";
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            TableRelation = "Attendance Journal Batch";
        }
        field(3; "Line No."; Integer)
        {
        }
        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
        }
        field(5; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(10; "Employee No."; Code[20])
        {
            Editable = false;
            TableRelation = Employee;
        }
        field(11; "Employee Name"; Code[50])
        {
        }
        field(20; "Attendance From"; Date)
        {
            Editable = false;
        }
        field(21; "Attendance To"; Date)
        {
            Editable = false;
        }
        field(51; "Present Days"; Integer)
        {
            CalcFormula = Count("Attendance Journal Detail" WHERE(Journal Template Name=FIELD(Journal Template Name),
                                                                   Journal Batch Name=FIELD(Journal Batch Name),
                                                                   Document No.=FIELD(Document No.),
                                                                   Journal Line No.=FIELD(Line No.),
                                                                   Employee No.=FIELD(Employee No.),
                                                                   Entry Type=FILTER(Present)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(52;"Absent Days";Integer)
        {
            CalcFormula = Count("Attendance Journal Detail" WHERE (Journal Template Name=FIELD(Journal Template Name),
                                                                   Journal Batch Name=FIELD(Journal Batch Name),
                                                                   Document No.=FIELD(Document No.),
                                                                   Journal Line No.=FIELD(Line No.),
                                                                   Employee No.=FIELD(Employee No.),
                                                                   Entry Type=CONST(Absent),
                                                                   Day Type=CONST(Working)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(53;"Paid Days";Decimal)
        {
            CalcFormula = Sum("Attendance Journal Detail".Days WHERE (Journal Template Name=FIELD(Journal Template Name),
                                                                      Journal Batch Name=FIELD(Journal Batch Name),
                                                                      Document No.=FIELD(Document No.),
                                                                      Journal Line No.=FIELD(Line No.),
                                                                      Employee No.=FIELD(Employee No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60;"Conflict Exists";Boolean)
        {
            CalcFormula = Exist("Attendance Journal Detail" WHERE (Journal Template Name=FIELD(Journal Template Name),
                                                                   Journal Batch Name=FIELD(Journal Batch Name),
                                                                   Document No.=FIELD(Document No.),
                                                                   Journal Line No.=FIELD(Line No.),
                                                                   Employee No.=FIELD(Employee No.),
                                                                   Conflict Exists=CONST(Yes)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5000;"Posting Date";Date)
        {
            Caption = 'Posting Date';
            ClosingDates = true;
        }
        field(5001;"Source Code";Code[10])
        {
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
        }
        field(5002;"Posting No. Series";Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(50000;Holidays;Integer)
        {
            CalcFormula = Count("Attendance Journal Detail" WHERE (Journal Template Name=FIELD(Journal Template Name),
                                                                   Journal Batch Name=FIELD(Journal Batch Name),
                                                                   Document No.=FIELD(Document No.),
                                                                   Journal Line No.=FIELD(Line No.),
                                                                   Employee No.=FIELD(Employee No.),
                                                                   Day Type=CONST(Holiday)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Journal Template Name","Journal Batch Name","Document No.","Line No.")
        {
            Clustered = true;
        }
        key(Key2;"Journal Template Name","Journal Batch Name","Posting Date","Document No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        AttJnlDetail.RESET;
        AttJnlDetail.SETRANGE("Document No.","Document No.");
        AttJnlDetail.SETRANGE("Journal Template Name","Journal Template Name");
        AttJnlDetail.SETRANGE("Journal Batch Name","Journal Batch Name");
        AttJnlDetail.SETRANGE("Employee No.","Employee No.");
        IF AttJnlDetail.FINDFIRST THEN
          AttJnlDetail.DELETEALL;
    end;

    trigger OnInsert()
    begin
        LOCKTABLE;
        AttJnlTemplate.GET("Journal Template Name");
        AttJnlBatch.GET("Journal Template Name","Journal Batch Name");
    end;

    var
        AttJnlTemplate: Record "33020552";
        AttJnlBatch: Record "33020553";
        AttJnlLine: Record "33020555";
        NoSeriesMgt: Codeunit "396";
        AttJnlDetail: Record "33020554";

    [Scope('Internal')]
    procedure SetUpNewLine(LastAttJnlLine: Record "33020555")
    begin
        AttJnlTemplate.GET("Journal Template Name");
        AttJnlBatch.GET("Journal Template Name","Journal Batch Name");
        AttJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
        AttJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
        IF AttJnlLine.FIND('-') THEN BEGIN
          "Posting Date" := LastAttJnlLine."Posting Date";
          "Document No." := LastAttJnlLine."Document No.";
        END ELSE BEGIN
          "Posting Date" := TODAY;
          IF AttJnlBatch."No. Series" <> '' THEN BEGIN
            CLEAR(NoSeriesMgt);
            "Document No." := NoSeriesMgt.TryGetNextNo(AttJnlBatch."No. Series","Posting Date");
          END;
        END;
        "Source Code" := AttJnlTemplate."Source Code";
        "Posting No. Series" := AttJnlBatch."Posting No. Series";
        Description := '';
    end;

    [Scope('Internal')]
    procedure EmptyLine(): Boolean
    begin
        EXIT(
          ("Employee No." = '') AND ("Paid Days" = 0));
    end;
}

