table 33020375 "Applicant Induction Checklist"
{

    fields
    {
        field(1; "Applicant No."; Code[20])
        {
        }
        field(2; Checklist; Code[15])
        {
            TableRelation = "Induction Checklist"."CheckList Code";
        }
        field(3; Submitted; Boolean)
        {

            trigger OnValidate()
            begin
                "Submitted By" := USERID;
                "Submitted Datetime" := CURRENTDATETIME;
            end;
        }
        field(4; "Submitted By"; Code[100])
        {
        }
        field(5; "Submitted Datetime"; DateTime)
        {
        }
    }

    keys
    {
        key(Key1; "Applicant No.", Checklist)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

