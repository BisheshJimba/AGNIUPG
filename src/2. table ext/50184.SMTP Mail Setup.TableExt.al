tableextension 50184 tableextension50184 extends "SMTP Mail Setup"
{
    fields
    {

        //Unsupported feature: Code Modification on "Authentication(Field 3).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF Authentication <> Authentication::Basic THEN BEGIN
          "User ID" := '';
          SetPassword('');
        END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        IF Authentication <> Authentication::Basic THEN BEGIN
         "User ID" := '';
         SetPassword('');
        END;
        */
        //end;


        //Unsupported feature: Code Modification on ""User ID"(Field 4).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD(Authentication,Authentication::Basic);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //TESTFIELD(Authentication,Authentication::Basic);
        */
        //end;
    }
}

