table 33020243 "Service Satisfaction Feedback"
{
    // // 01/17/2013 Suman Maharjan
    //  Option added for the answer as per Agni


    fields
    {
        field(1; "Service Order No."; Code[20])
        {
            TableRelation = "Posted Serv. Order Header".No.;
        }
        field(2; "Question No."; Code[20])
        {
            TableRelation = "Service Satisfaction Questions".Code;

            trigger OnValidate()
            begin
                QuestionRec.SETRANGE(Code, "Question No.");
                IF QuestionRec.FINDFIRST THEN BEGIN
                    Question := QuestionRec.Question;
                    //MODIFY;
                END;
            end;
        }
        field(3; Question; Text[250])
        {
        }
        field(4; Answer; Integer)
        {
            BlankNumbers = BlankZero;

            trigger OnValidate()
            begin
                IF Answer = 0 THEN
                    Description := Description::" ";
                IF Answer IN [1, 2, 3, 4] THEN BEGIN
                    Description := Description::Unacceptable;
                END
                ELSE IF Answer IN [5, 6, 7] THEN BEGIN
                    Description := Description::Average;
                END ELSE IF Answer IN [8, 9] THEN BEGIN
                    Description := Description::Good;
                END ELSE IF Answer = 10 THEN BEGIN
                    Description := Description::Excellent;
                END;

                IF Answer > 10 THEN
                    ERROR('The valid range is from 1 to 10. Please enter the valid score.');
            end;
        }
        field(5; Comment; Text[250])
        {
        }
        field(6; "Filled By"; Option)
        {
            OptionCaption = 'Owner,Driver,Helper';
            OptionMembers = Owner,Driver,Helper;
        }
        field(50000; "Order No."; Code[20])
        {
            Editable = false;
        }
        field(50001; "Invoice Posting Date"; Date)
        {
            CalcFormula = Lookup("Sales Invoice Header"."Posting Date" WHERE(Service Order No.=FIELD(Order No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002;"Location Code";Code[20])
        {
            CalcFormula = Lookup("Sales Invoice Header"."Location Code" WHERE (Service Order No.=FIELD(Order No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003;Description;Option)
        {
            OptionCaption = ' ,Unacceptable,Average,Good,Excellent';
            OptionMembers = " ",Unacceptable,"Average",Good,Excellent;
        }
    }

    keys
    {
        key(Key1;"Service Order No.","Question No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        /*PostedServHeader.RESET;
        PostedServHeader.SETRANGE("No.","Service Order No.");
        IF PostedServHeader.FINDFIRST THEN
          "Order No." := PostedServHeader."Order No.";
         */

    end;

    var
        QuestionRec: Record "33020244";
        PostedServHeader: Record "25006149";
}

