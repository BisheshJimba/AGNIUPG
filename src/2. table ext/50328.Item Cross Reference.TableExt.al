tableextension 50328 tableextension50328 extends "Item Cross Reference"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 2)".

        modify("Cross-Reference Type No.")
        {
            TableRelation = IF (Cross-Reference Type=CONST(Customer)) Customer.No.
                            ELSE IF (Cross-Reference Type=CONST(Vendor)) Vendor.No.;
        }
    }

    //Unsupported feature: Property Modification (Length) on "GetItemDescription(PROCEDURE 4).VariantCode(Parameter 1001)".

}

