tableextension 50380 tableextension50380 extends "Service Contract Header"
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on ""Ship-to Name"(Field 23)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Ship-to Address"(Field 24)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Ship-to Address 2"(Field 25)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Ship-to Post Code"(Field 26)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Ship-to City"(Field 27)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Calcd. Annual Amount"(Field 40)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Posted Invoices"(Field 57)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Unposted Invoices"(Field 58)".


        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 84)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Ship-to County"(Field 91)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Ship-to Country/Region Code"(Field 94)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Ship-to Name 2"(Field 97)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Contract Invoice Amount"(Field 100)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Contract Prepaid Amount"(Field 101)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Contract Discount Amount"(Field 102)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Contract Cost Amount"(Field 103)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Contract Gain/Loss Amount"(Field 104)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Posted Credit Memos"(Field 106)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Unposted Credit Memos"(Field 107)".

    }

    //Unsupported feature: Code Modification on "UpdateCust(PROCEDURE 25)".

    //procedure UpdateCust();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF Cont.GET(ContactNo) THEN BEGIN
      "Contact No." := Cont."No.";
      "Phone No." := Cont."Phone No.";
      "E-Mail" := Cont."E-Mail";
      IF Cont.Type = Cont.Type::Person THEN
        "Contact Name" := Cont.Name
      ELSE
        IF Cust.GET("Customer No.") THEN
    #9..36
       ("Bill-to Customer No." = '')
    THEN
      VALIDATE("Bill-to Contact No.","Contact No.");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4
      IF Cont.Type = Cont.Type::Company THEN
    #6..39
    */
    //end;


    //Unsupported feature: Code Modification on "UpdateBillToCust(PROCEDURE 26)".

    //procedure UpdateBillToCust();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF Cont.GET(ContactNo) THEN BEGIN
      "Bill-to Contact No." := Cont."No.";
      IF Cont.Type = Cont.Type::Person THEN
        "Bill-to Contact" := Cont.Name
      ELSE
        IF Cust.GET("Bill-to Customer No.") THEN
    #7..25
          ERROR(Text044,Cont."No.",Cont.Name,"Bill-to Customer No.");
    END ELSE
      ERROR(Text051,Cont."No.",Cont.Name);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IF Cont.GET(ContactNo) THEN BEGIN
      "Bill-to Contact No." := Cont."No.";
      IF Cont.Type = Cont.Type::Company THEN
    #4..28
    */
    //end;
}

