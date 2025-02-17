table 33019869 "Max. Vehicle Discount"
{

    fields
    {
        field(1; "User ID"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(2; "Model Version Filter"; Code[180])
        {

            trigger OnValidate()
            begin
                IF "Model Version Filter" <> xRec."Model Version Filter" THEN BEGIN
                    MaxVehDiscountLine.RESET;
                    MaxVehDiscountLine.SETRANGE("User ID", "User ID");
                    MaxVehDiscountLine.SETRANGE("Model Version Filter", xRec."Model Version Filter");
                    IF MaxVehDiscountLine.FINDFIRST THEN BEGIN
                        ERROR('Max. Vehicle Discount Limit Lines Exist. You cannot rename the record!!!');
                    END;
                END;
            end;
        }
        field(3; Blocked; Boolean)
        {
        }
        field(4; "Discount Percent without VAT"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "User ID", "Model Version Filter")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        MaxVehDiscount: Record "33019869";
        MaxVehDiscountLine: Record "33019861";
        PrevModelFilter: Text[180];
}

