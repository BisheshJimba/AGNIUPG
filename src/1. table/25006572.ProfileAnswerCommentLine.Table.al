table 25006572 "Profile Answer Comment Line"
{
    Caption = 'Profile Answer Comment Line';
    DrillDownPageID = 25006712;
    LookupPageID = 25006712;

    fields
    {
        field(10; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = Contact;
        }
        field(20; "Profile Questionnaire Code"; Code[10])
        {
            Caption = 'Profile Questionnaire Code';
            TableRelation = "Profile Questionnaire Header".Code;
        }
        field(30; "Answer Line No."; Integer)
        {
            Caption = 'Answer Line No.';
        }
        field(40; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(50; Date; Date)
        {
            Caption = 'Date';
        }
        field(60; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(70; Comment; Text[80])
        {
            Caption = 'Comment';
        }
        field(80; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Contact No.", "Profile Questionnaire Code", "Answer Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        "Last Date Modified" := TODAY;
    end;

    [Scope('Internal')]
    procedure SetUpNewLine()
    var
        AnswerCommentLine: Record "25006572";
    begin
        AnswerCommentLine.SETRANGE("Contact No.", "Contact No.");
        AnswerCommentLine.SETRANGE("Profile Questionnaire Code", "Profile Questionnaire Code");
        AnswerCommentLine.SETRANGE("Answer Line No.", "Answer Line No.");
        AnswerCommentLine.SETRANGE(Date, WORKDATE);
        IF AnswerCommentLine.ISEMPTY THEN
            Date := WORKDATE;
    end;
}

