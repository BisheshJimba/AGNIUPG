table 25006210 "Quest. Subj. Group Q. Answer"
{
    Caption = 'Quest. Subj. Group Q. Answer';
    LookupPageID = 25006289;

    fields
    {
        field(10; "Questionary Subject Group Code"; Code[20])
        {
            Caption = 'Questionary Subject Group Code';
            NotBlank = true;
            TableRelation = "Questionary Subject Group".Code;
        }
        field(20; "Question No."; Integer)
        {
            Caption = 'Question No.';
            MinValue = 1;
            TableRelation = "Quest. Subj. Group Question".No. WHERE(Questionary Subject Group Code=FIELD(Questionary Subject Group Code));
        }
        field(30;"Answer Text";Text[250])
        {
            Caption = 'Answer Text';
            NotBlank = true;

            trigger OnValidate()
            begin
                Question.GET("Questionary Subject Group Code", "Question No.");
                IF Question."Answer Type" IN [Question."Answer Type"::Option] THEN
                  "Answer Text" := UPPERCASE("Answer Text");
            end;
        }
        field(110;"Sorting No.";Integer)
        {
            Caption = 'Sorting No.';
        }
    }

    keys
    {
        key(Key1;"Questionary Subject Group Code","Question No.","Answer Text")
        {
            Clustered = true;
        }
        key(Key2;"Questionary Subject Group Code","Question No.","Sorting No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Question: Record "25006209";
}

