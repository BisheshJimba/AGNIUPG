table 33020304 "HR Permission"
{

    fields
    {
        field(1; "User ID"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(2; "Concerned Department"; Boolean)
        {
        }
        field(3; Store; Boolean)
        {
        }
        field(4; "CVD-Service Manager"; Boolean)
        {
        }
        field(5; "PCD-Service Manager"; Boolean)
        {
        }
        field(6; "Administrative Department"; Boolean)
        {
        }
        field(7; "IT Department"; Boolean)
        {
        }
        field(8; Library; Boolean)
        {
        }
        field(9; "Housing Loan"; Boolean)
        {
        }
        field(10; "Vehicle Finance"; Boolean)
        {
        }
        field(11; Welfare; Boolean)
        {
        }
        field(12; "Account Department"; Boolean)
        {
        }
        field(13; "Permission to Send Mail"; Boolean)
        {
        }
        field(14; "Application Proces. Authority"; Boolean)
        {
        }
        field(15; "Aproval/Disaproval Auth. Leave"; Boolean)
        {
        }
        field(16; "Leave Earn"; Boolean)
        {
        }
        field(17; "Admin Permission"; Boolean)
        {
        }
        field(18; "HR Admin"; Boolean)
        {
        }
        field(19; "Leave Date Adjust"; Boolean)
        {
        }
        field(20; "Travel Order Post"; Boolean)
        {
        }
        field(21; "Travel Order Approve"; Boolean)
        {
        }
        field(22; Manager; Boolean)
        {
        }
        field(23; "Branch Admin"; Boolean)
        {
        }
        field(24; "Super Permission"; Boolean)
        {
        }
        field(25; "HR Master"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "User ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

