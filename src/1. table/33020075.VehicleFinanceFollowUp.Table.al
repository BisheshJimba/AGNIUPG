table 33020075 "Vehicle Finance Follow Up"
{

    fields
    {
        field(1; "Loan No."; Code[20])
        {
            Editable = false;
            TableRelation = "Vehicle Finance Header";
        }
        field(2; "Follow-Up Date"; Date)
        {
            Editable = true;
        }
        field(3; "Plan Type"; Option)
        {
            OptionCaption = ' ,Call,Email,Visit,Letter Issue,Capture';
            OptionMembers = " ",Call,Email,Visit,"Letter Issue",Capture;
        }
        field(4; Remarks; Text[250])
        {
        }
        field(5; "Responsible Person Code"; Code[10])
        {
            Editable = false;
            TableRelation = Salesperson/Purchaser;
        }
        field(6;"Responsible Person Name";Text[50])
        {
            CalcFormula = Lookup(Salesperson/Purchaser.Name WHERE (Code=FIELD(Responsible Person Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7;"Customer Name";Text[50])
        {
            CalcFormula = Lookup("Vehicle Finance Header"."Customer Name" WHERE (Loan No.=FIELD(Loan No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;"Due Installment as of Today";Integer)
        {
            CalcFormula = Lookup("Vehicle Finance Header"."Due Installment as of Today" WHERE (Loan No.=FIELD(Loan No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9;"Total Due as of Today";Decimal)
        {
            CalcFormula = Lookup("Vehicle Finance Header"."Total Due as of Today" WHERE (Loan No.=FIELD(Loan No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(10;"EMI Amount";Decimal)
        {
            CalcFormula = Lookup("Vehicle Finance Lines"."EMI Amount" WHERE (Loan No.=FIELD(Loan No.),
                                                                             Installment No.=CONST(1)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11;"Next Follow Up Date";Date)
        {

            trigger OnValidate()
            begin
                VehFinFUReg.RESET;
                VehFinFUReg.SETRANGE("Loan No.","Loan No.");
                VehFinFUReg.SETRANGE("Follow-Up Date",xRec."Next Follow Up Date");
                IF VehFinFUReg.FINDFIRST THEN
                  VehFinFUReg.DELETEALL;
                IF "Next Follow Up Date" <> 0D THEN BEGIN
                  CLEAR(VehFinFUReg);
                  VehFinFUReg.RESET;
                  VehFinFUReg.INIT;
                  VehFinFUReg."Loan No." := "Loan No.";
                  IF "Next Follow Up Date" <= TODAY THEN
                    ERROR('Next Follow Up Date cannot be less or equal to today''s Date');
                  VehFinFUReg."Follow-Up Date" := "Next Follow Up Date";
                  VehFinFUReg."Plan Type" := VehFinFUReg."Plan Type"::Call;
                  VehFinFUReg."Responsible Person Code" := "Responsible Person Code";
                  //ZM Sep 14, 2016 >>
                  VehFinFUReg."Mobile No." := "Mobile No.";
                  VehFinFUReg."Phone No."  := "Phone No.";
                  VehFinFUReg."Phone No. 2" := "Phone No. 2";
                  //ZM Sep 14, 2016 <<
                  VehFinFUReg.INSERT;
                END;
            end;
        }
        field(12;"User ID";Code[20])
        {
        }
        field(13;"Payment Type";Option)
        {
            OptionMembers = " ",Cash,Bank;
        }
        field(14;"Bank Account No.";Code[20])
        {
            TableRelation = "Bank Account".No.;
        }
        field(15;"Customer No.";Code[20])
        {
            Editable = false;
        }
        field(16;"Phone No.";Text[30])
        {
            CalcFormula = Lookup(Customer."Phone No." WHERE (No.=FIELD(Customer No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(17;"Phone No. 2";Text[30])
        {
            CalcFormula = Lookup(Customer."Fax No." WHERE (No.=FIELD(Customer No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(18;"Mobile No.";Code[50])
        {
            CalcFormula = Lookup(Customer."Mobile No." WHERE (No.=FIELD(Customer No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(19;"Last Payment Date";Date)
        {
        }
        field(20;"Due Days";Integer)
        {
            CalcFormula = Lookup("Vehicle Finance Header"."No of Due Days" WHERE (Loan No.=FIELD(Loan No.)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Loan No.","Follow-Up Date","Plan Type")
        {
            Clustered = true;
        }
        key(Key2;"Customer No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        VehFinFUReg: Record "33020075";
}

