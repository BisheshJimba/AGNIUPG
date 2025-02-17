tableextension 50208 tableextension50208 extends "Approval Entry"
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 13)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Pending Approvals"(Field 21)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Number of Approved Requests"(Field 26)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Number of Rejected Requests"(Field 27)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Related to Change"(Field 31)".

        field(10000; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Gen. Journal Template";
        }
        field(10001; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name WHERE(Journal Template Name=FIELD(Journal Template Name));
        }
        field(10002; "Receiver Name"; Text[250])
        {
        }
        field(10003; "Sender Name"; Text[250])
        {
        }
        field(50000; "Custom Approval"; Boolean)
        {
        }
    }

    //Unsupported feature: Variable Insertion (Variable: GenJnlLine) (VariableCollection) on "ShowRecord(PROCEDURE 1)".


    //Unsupported feature: Variable Insertion (Variable: GenJnlTemplate) (VariableCollection) on "ShowRecord(PROCEDURE 1)".


    //Unsupported feature: Variable Insertion (Variable: ProcurementMemo) (VariableCollection) on "ShowRecord(PROCEDURE 1)".


    //Unsupported feature: Variable Insertion (Variable: FieldRef) (VariableCollection) on "ShowRecord(PROCEDURE 1)".


    //Unsupported feature: Variable Insertion (Variable: ProcType) (VariableCollection) on "ShowRecord(PROCEDURE 1)".



    //Unsupported feature: Code Modification on "ShowRecord(PROCEDURE 1)".

    //procedure ShowRecord();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF NOT RecRef.GET("Record ID to Approve") THEN
      EXIT;
    RecRef.SETRECFILTER;
    PageManagement.PageRun(RecRef);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IF NOT RecRef.GET("Record ID to Approve") THEN
      EXIT;
    //NCHL-NPI_1.00 >>
    {IF "Table ID" = DATABASE::"Gen. Journal Line" THEN BEGIN
      RecRef.SETTABLE(GenJnlLine);
      GenJnlTemplate.GET(GenJnlLine."Journal Template Name");
      CASE GenJnlTemplate.Type OF
        GenJnlTemplate.Type::General:PAGE.RUN(PAGE::"General Journal",GenJnlLine);
        GenJnlTemplate.Type::Payments:PAGE.RUN(PAGE::"Payment Journal",GenJnlLine);
        GenJnlTemplate.Type::"Cash Receipts":PAGE.RUN(PAGE::"Cash Receipt Journal",GenJnlLine);
      END;
    END ELSE BEGIN//NCHL-NPI_1.00 <<
      RecRef.SETRECFILTER;
      PageManagement.PageRun(RecRef);
    END;
    }
    IF "Table ID" = DATABASE::"Procurement Memo" THEN BEGIN// aakrista 4/27/2022 for procurement memo
       //RecRef.SETTABLE(ProcurementMemo);
       //RecRef.SETRECFILTER;
       //PageManagement.PageRun(RecRef);
       RecRef.SETTABLE(ProcurementMemo);
       RecRef.SETRECFILTER;
       FieldRef := RecRef.FIELD(ProcurementMemo.FIELDNO("Procurement Type"));
       ProcType := FieldRef.VALUE;
       ProcurementMemo.SETRANGE("Memo No.","Document No.");
       IF ProcurementMemo.FINDFIRST THEN BEGIN
         IF ProcType= ProcType::Purchase THEN
          PAGE.RUN(50056,ProcurementMemo)
         ELSE IF ProcType = ProcType::Sales THEN
          PAGE.RUN(50068,ProcurementMemo)
         ELSE IF ProcType = ProcType::"Veh. Sales Memo" THEN
          PAGE.RUN(50073,ProcurementMemo);
       END;
    END ELSE BEGIN
      RecRef.SETRECFILTER;
      PageManagement.PageRun(RecRef);
    END;
    */
    //end;
}

