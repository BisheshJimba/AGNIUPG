pageextension 50072 pageextension50072 extends "Office Contact Details Dlg"
{
    layout
    {

        //Unsupported feature: Code Modification on "Control 8.OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        AssociateToCompany := Type = Type::Person;
        AssociateEnabled := Type = Type::Person;
        IF Type = Type::Company THEN BEGIN
          CLEAR("Company No.");
          CLEAR("Company Name");
        END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        AssociateToCompany := Type = Type::Company;
        AssociateEnabled := Type = Type::Company;
        IF Type = Type::" " THEN BEGIN
        #4..6
        */
        //end;
    }


    //Unsupported feature: Code Modification on "OnInit".

    //trigger OnInit()
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    AssociateToCompany := Type = Type::Person;
    AssociateEnabled := AssociateToCompany;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    AssociateToCompany := Type = Type::Company;
    AssociateEnabled := AssociateToCompany;
    */
    //end;
}

