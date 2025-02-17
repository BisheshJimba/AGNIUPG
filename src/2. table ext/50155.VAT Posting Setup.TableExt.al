tableextension 50155 tableextension50155 extends "VAT Posting Setup"
{
    fields
    {

        //Unsupported feature: Code Modification on ""VAT Identifier"(Field 13).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        "VAT %" := GetVATPtc;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        "VAT %" := GetVATPtc;

        // VAT1.00 >>
        VATPostingSetup.RESET;
        VATPostingSetup.SETRANGE("VAT Identifier","VAT Identifier");
        IF VATPostingSetup.FINDFIRST THEN
          ERROR(Text100);
        MESSAGE(Text101);
        // VAT1.00 <<
        */
        //end;
        field(57010; "Localized VAT Identifier"; Option)
        {
            Description = 'VAT1.00';
            OptionCaption = ' ,Taxable Import Purchase,Exempt Purchase,Taxable Local Purchase,Taxable Capex Purchase,Taxable Sales,Non Taxable Sales,Exempt Sales';
            OptionMembers = " ","Taxable Import Purchase","Exempt Purchase","Taxable Local Purchase","Taxable Capex Purchase","Taxable Sales","Non Taxable Sales","Exempt Sales";
        }
    }

    var
        VATPostingSetup: Record "325";
        Text100: Label 'VAT Identifier already exists.';
        Text101: Label 'Please select Localised VAT Identifier to allow post the transaction';
}

