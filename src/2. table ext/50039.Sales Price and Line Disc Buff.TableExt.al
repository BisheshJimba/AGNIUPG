tableextension 50039 tableextension50039 extends "Sales Price and Line Disc Buff"
{
    fields
    {
        modify("Code")
        {
            TableRelation = IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST("Item Disc. Group")) "Item Discount Group";
        }
        modify("Sales Code")
        {
            TableRelation = IF ("Sales Type" = CONST("Customer Price/Disc. Group"),
                                "Line Type" = CONST("Sales Line Discount")) "Customer Discount Group"
            ELSE IF ("Sales Type" = CONST("Customer Price/Disc. Group"),
                                         "Line Type" = CONST("Sales Price")) "Customer Price Group"
            ELSE IF ("Sales Type" = CONST(Customer)) Customer;
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5700)".

    }
}

