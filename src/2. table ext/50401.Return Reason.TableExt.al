tableextension 50401 tableextension50401 extends "Return Reason"
{
    fields
    {
        modify("Code")
        {
            TableRelation = "Reason Code";
        }

        //Unsupported feature: Code Insertion on "Code(Field 1)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*
        ReasonCode.RESET;
        ReasonCode.SETRANGE(ReasonCode.Code,Code);
        IF ReasonCode.FINDFIRST THEN BEGIN
          Description := ReasonCode.Description;
        END;
        */
        //end;

        //Unsupported feature: Property Deletion (NotBlank) on "Code(Field 1)".

    }


    //Unsupported feature: Code Insertion on "OnDelete".

    //trigger OnDelete()
    //begin
    /*
    ReasonCode.RESET;
    ReasonCode.SETRANGE(ReasonCode.Code,Code);
    IF ReasonCode.FINDFIRST THEN BEGIN
      ReasonCode.DELETE;
    END;
    */
    //end;


    //Unsupported feature: Code Insertion on "OnModify".

    //trigger OnModify()
    //begin
    /*
    ReasonCode.RESET;
    ReasonCode.SETRANGE(ReasonCode.Code,Code);
    IF ReasonCode.FINDFIRST THEN BEGIN
      ReasonCode.Code := Code;
      ReasonCode.Description := Description;
      ReasonCode.MODIFY;
    END;
    */
    //end;

    var
        ReasonCode: Record "231";
}

