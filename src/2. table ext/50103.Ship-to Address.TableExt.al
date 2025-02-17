tableextension 50103 tableextension50103 extends "Ship-to Address"
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
        field(5901; "Province No."; Option)
        {
            OptionCaption = ' ,PROVINCE 1,PROVINCE 2,BAGMATI PROVINCE,GANDAKI PROVINCE,PROVINCE 5,KARNALI PROVINCE,SUDUR PACHIM PROVINCE';
            OptionMembers = " ","PROVINCE 1"," PROVINCE 2"," BAGMATI PROVINCE"," GANDAKI PROVINCE"," PROVINCE 5"," KARNALI PROVINCE"," SUDUR PACHIM PROVINCE";
        }
    }
}

