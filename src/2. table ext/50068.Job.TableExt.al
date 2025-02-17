tableextension 50068 tableextension50068 extends Job
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 30)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Scheduled Res. Qty."(Field 49)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Scheduled Res. Gr. Qty."(Field 56)".

        modify("Bill-to City")
        {
            TableRelation = IF ("Bill-to Country/Region Code" = CONST()) "Post Code".City
            ELSE IF ("Bill-to Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Bill-to Country/Region Code"));
        }
        modify("Bill-to Post Code")
        {
            TableRelation = IF ("Bill-to Country/Region Code" = CONST()) "Post Code"
            ELSE IF ("Bill-to Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Bill-to Country/Region Code"));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Total WIP Cost Amount"(Field 1005)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Total WIP Cost G/L Amount"(Field 1006)".


        //Unsupported feature: Property Modification (CalcFormula) on ""WIP G/L Posting Date"(Field 1009)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Recog. Sales Amount"(Field 1017)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Recog. Sales G/L Amount"(Field 1018)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Recog. Costs Amount"(Field 1019)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Recog. Costs G/L Amount"(Field 1020)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Total WIP Sales Amount"(Field 1021)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Total WIP Sales G/L Amount"(Field 1022)".


        //Unsupported feature: Property Modification (CalcFormula) on ""WIP Completion Calculated"(Field 1023)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Next Invoice Date"(Field 1024)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Applied Costs G/L Amount"(Field 1028)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Applied Sales G/L Amount"(Field 1029)".


        //Unsupported feature: Property Modification (CalcFormula) on ""WIP Completion Posted"(Field 1034)".

    }

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
    #7..23
          ERROR(ContactBusRelErr,Cont."No.",Cont.Name,"Bill-to Customer No.");
    END ELSE
      ERROR(ContactBusRelMissingErr,Cont."No.",Cont.Name);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IF Cont.GET(ContactNo) THEN BEGIN
      "Bill-to Contact No." := Cont."No.";
      IF Cont.Type = Cont.Type::Company THEN
    #4..26
    */
    //end;
}

