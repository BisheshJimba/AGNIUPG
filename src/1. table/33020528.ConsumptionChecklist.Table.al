table 33020528 "Consumption Checklist"
{

    fields
    {
        field(1; "Job Card No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Item Type"; Option)
        {
            OptionCaption = ' ,Paint,Paint Material';
            OptionMembers = " ",Paint,"Paint Material";
        }
        field(4; "Item No."; Code[20])
        {
            TableRelation = Item;

            trigger OnValidate()
            begin
                GetItemDescription;
            end;
        }
        field(5; Description; Text[50])
        {
        }
        field(6; Quantity; Decimal)
        {

            trigger OnValidate()
            begin
                CalculateAmount;
            end;
        }
        field(7; Rate; Decimal)
        {

            trigger OnValidate()
            begin
                CalculateAmount;
            end;
        }
        field(8; Amount; Decimal)
        {
        }
        field(9; Remarks; Text[30])
        {
        }
        field(10; "Posted Job Card No."; Code[20])
        {
        }
        field(11; Reversed; Boolean)
        {
        }
        field(12; "Modified By"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(13; "Modified Date"; Date)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Job Card No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Modified By" := USERID;
        "Modified Date" := TODAY;
    end;

    trigger OnModify()
    begin
        "Modified By" := USERID;
        "Modified Date" := TODAY;
    end;

    local procedure GetItemDescription()
    var
        Item: Record "27";
    begin
        Description := '';
        Item.GET("Item No.");
        Description := Item.Description;
    end;

    local procedure CalculateAmount()
    begin
        Amount := Quantity * Rate;
    end;
}

