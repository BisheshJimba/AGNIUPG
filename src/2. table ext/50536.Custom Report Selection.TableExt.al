tableextension 50536 tableextension50536 extends "Custom Report Selection"
{
    fields
    {
        modify("Source No.")
        {
            TableRelation = IF (Source Type=CONST(18)) Customer.No.
                            ELSE IF (Source Type=CONST(23)) Vendor.No.;
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Report Caption"(Field 6)".

        modify("Email Body Layout Code")
        {
            TableRelation = "Custom Report Layout" WHERE(Code = FIELD(Email Body Layout Code),
                                                          Report ID=FIELD(Report ID));
        }
    }
}

