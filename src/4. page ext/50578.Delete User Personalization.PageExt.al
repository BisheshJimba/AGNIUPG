pageextension 50578 pageextension50578 extends "Delete User Personalization"
{
    var
        DelUP: Record "50010";


    //Unsupported feature: Code Insertion on "OnOpenPage".

    //trigger OnOpenPage()
    //begin
    /*
    //AGNI2017CU8 >>
    DelUP.RESET;
    DelUP.INIT;
    DelUP."User ID" := USERID;
    DelUP.INSERT;
    ERROR('You do not have permission to delete User Personalization');
    //AGNI2017CU8 <<
    */
    //end;
}

