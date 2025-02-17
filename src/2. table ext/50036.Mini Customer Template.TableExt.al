tableextension 50036 tableextension50036 extends "Mini Customer Template"
{
    fields
    {
        modify(City)
        {
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
        }
        modify("Post Code")
        {
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code"
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
        }
    }

    //Unsupported feature: Code Modification on "InsertCustomerFromTemplate(PROCEDURE 16)".

    //procedure InsertCustomerFromTemplate();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    Customer.SetInsertFromTemplate(TRUE);
    Customer.INSERT(TRUE);
    RecRef.GETTABLE(Customer);
    ConfigTemplateMgt.UpdateRecord(ConfigTemplateHeader,RecRef);
    RecRef.SETTABLE(Customer);

    DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader,Customer."No.",DATABASE::Customer);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3
    //ConfigTemplateMgt.UpdateRecord(ConfigTemplateHeader,RecRef);
    #5..7
    */
    //end;
}

