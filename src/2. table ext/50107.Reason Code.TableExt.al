tableextension 50107 tableextension50107 extends "Reason Code"
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on ""Contract Gain/Loss Amount"(Field 5901)".

        field(50000; Group; Option)
        {
            OptionCaption = ' ,Accessories,Return,Service,Spares,Hire Purchase,OT Pending,Warranty,Sahamati,Wave Penalty';
            OptionMembers = " ",Accessories,Return,Service,Spares,"Hire Purchase","OT Pending",Warranty,Sahamati,"Wave Penalty";
        }
    }


    //Unsupported feature: Code Insertion on "OnDelete".

    //trigger OnDelete()
    //begin
    /*
     ReturnReasonCode.RESET;
     ReturnReasonCode.SETRANGE(ReturnReasonCode.Code,Code);
     IF ReturnReasonCode.FINDFIRST THEN BEGIN
        ReturnReasonCode.DELETE;
     END;
    */
    //end;


    //Unsupported feature: Code Insertion on "OnInsert".

    //trigger OnInsert()
    //begin
    /*
    ReturnReasonCode.INIT;
    ReturnReasonCode.Code := Code;
    ReturnReasonCode.Description := Description;
    ReturnReasonCode.INSERT;
    */
    //end;


    //Unsupported feature: Code Insertion on "OnModify".

    //trigger OnModify()
    //begin
    /*
     ReturnReasonCode.RESET;
     ReturnReasonCode.SETRANGE(ReturnReasonCode.Code,Code);
     IF ReturnReasonCode.FINDFIRST THEN BEGIN
      ReturnReasonCode.Code := Code;
      ReturnReasonCode.Description := Description;
      ReturnReasonCode.MODIFY;
     END;
    */
    //end;

    var
        ReturnReasonCode: Record "6635";
}

