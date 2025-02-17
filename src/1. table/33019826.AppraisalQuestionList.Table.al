table 33019826 "Appraisal Question List"
{

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Employee No."; Code[20])
        {
        }
        field(3; Department; Code[20])
        {
            TableRelation = "Location Master".Code;
        }
        field(4; Questions; Text[250])
        {
        }
        field(5; "Total Marks"; Decimal)
        {
        }
        field(6; "Marks Obtained"; Decimal)
        {

            trigger OnValidate()
            var
                Apprisal: Record "33020361";
                ApprQue: Record "33019826";
                MO: Decimal;
                Toatl: Decimal;
                Avg: Decimal;
            begin
                IF "Marks Obtained" > "Total Marks" THEN
                    ERROR('Obtained marks cannot be greater than Total Marks.');

                Apprisal.RESET;
                Apprisal.SETRANGE("Entry No.", "No.");
                IF Apprisal.FINDFIRST THEN BEGIN
                    Apprisal."Total Average" := 0;
                    ApprQue.RESET;
                    ApprQue.SETRANGE("No.", "No.");
                    ApprQue.SETFILTER(Department, Department);
                    ApprQue.SETRANGE("Appraisal Type", "Appraisal Type");
                    ApprQue.SETFILTER("Question Code", '<>%1', "Question Code");
                    ApprQue.CALCSUMS("Marks Obtained");
                    ApprQue.CALCSUMS("Total Marks");
                    MO := ApprQue."Marks Obtained" + "Marks Obtained"; //if not added here will take previous one
                    Toatl := ApprQue."Total Marks" + "Total Marks"; //if not added here will take previous one
                    Apprisal."Total Average" := (MO / Toatl) * 100;

                    Apprisal.MODIFY;

                END;
            end;
        }
        field(7; "Question Code"; Code[20])
        {
        }
        field(8; "Appraisal Type"; Option)
        {
            OptionMembers = " ",Self,Manager,"Manager 360";
        }
        field(9; Posted; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "No.", "Question Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

