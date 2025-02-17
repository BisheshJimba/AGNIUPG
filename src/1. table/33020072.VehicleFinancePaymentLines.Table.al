table 33020072 "Vehicle Finance Payment Lines"
{
    DrillDownPageID = 33020076;
    LookupPageID = 33020076;

    fields
    {
        field(1; "Loan No."; Code[20])
        {
            TableRelation = "Vehicle Finance Header"."Loan No.";
        }
        field(2; "Installment No."; Integer)
        {
            TableRelation = "Vehicle Finance Lines"."Installment No." WHERE(Loan No.=FIELD(Loan No.));
        }
        field(3;"Line No.";Integer)
        {
        }
        field(4;"Delay by No. of Days";Decimal)
        {
        }
        field(5;"Principal Paid";Decimal)
        {
        }
        field(6;"Interest Paid";Decimal)
        {
        }
        field(7;"Penalty Paid";Decimal)
        {
        }
        field(8;"Rebate Adjusted";Decimal)
        {
        }
        field(9;"Actual Balance";Decimal)
        {
        }
        field(10;"Insurance Paid";Decimal)
        {
        }
        field(11;"Payment Date";Date)
        {
        }
        field(12;"Line Cleared";Boolean)
        {
        }
        field(13;"Duration of days fr Prev. Mnth";Integer)
        {
        }
        field(14;"Remaining Principal Amount";Decimal)
        {
        }
        field(15;"Pending Interest";Decimal)
        {
        }
        field(16;"G/L Receipt No.";Code[20])
        {
        }
        field(17;Indentation;Integer)
        {
        }
        field(18;"Calculated Penalty";Decimal)
        {
        }
        field(19;"G/L Posting Date";Date)
        {
        }
        field(20;"VF Posting Description";Text[100])
        {
        }
        field(21;"Bank Account No.";Code[20])
        {
            TableRelation = "Bank Account".No.;
        }
        field(22;"Prepayment Paid";Decimal)
        {
        }
        field(23;"Insurance Interest Paid";Decimal)
        {
        }
        field(50000;"Other Charges Paid";Decimal)
        {
        }
        field(50001;"Posting Type";Option)
        {
            OptionCaption = ' ,Principal,Interest,Penalty,Service Charge,Insurance,Other Charges,Prepayment,Insurance Interest,Interest on CAD,Capitalization';
            OptionMembers = " ",Principal,Interest,Penalty,"Service Charge",Insurance,"Other Charges",Prepayment,"Insurance Interest","Interest on CAD",Capitalization;
        }
        field(50002;"VF Receipt No.";Code[20])
        {
        }
        field(50003;"Payment Description";Text[120])
        {
            Description = 'SRT';
        }
        field(50004;"G/L Posting DateFilter";Date)
        {
            FieldClass = FlowFilter;
        }
        field(50005;"Payment DateFilter";Date)
        {
            FieldClass = FlowFilter;
        }
        field(50006;"User ID";Code[50])
        {
            TableRelation = "User Setup";
        }
        field(50007;"Responsibility Center";Code[20])
        {
            TableRelation = "Responsibility Center";
        }
        field(50008;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(50009;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(50010;"User ID - Before Posting";Code[50])
        {
            TableRelation = User;
        }
        field(50011;"Journal Batch Name";Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE (Journal Template Name=CONST(VF-THP));
        }
        field(50012;"CAD Interest Paid";Decimal)
        {
        }
        field(33019961;"Accountability Center";Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
    }

    keys
    {
        key(Key1;"Loan No.","Installment No.","Line No.")
        {
            Clustered = true;
            SumIndexFields = "Delay by No. of Days","Principal Paid","Interest Paid","Penalty Paid","Rebate Adjusted","Insurance Paid","Calculated Penalty","Other Charges Paid";
        }
        key(Key2;"Payment Date")
        {
            SumIndexFields = "Delay by No. of Days","Principal Paid","Interest Paid","Penalty Paid","Rebate Adjusted","Insurance Paid","Calculated Penalty","Other Charges Paid";
        }
        key(Key3;"Insurance Paid","Other Charges Paid")
        {
            SumIndexFields = "Delay by No. of Days","Principal Paid","Interest Paid","Penalty Paid","Rebate Adjusted","Insurance Paid","Calculated Penalty","Other Charges Paid";
        }
        key(Key4;"G/L Receipt No.")
        {
        }
        key(Key5;"Loan No.","Installment No.","Posting Type","Insurance Paid")
        {
            SumIndexFields = "Delay by No. of Days","Principal Paid","Interest Paid","Penalty Paid","Rebate Adjusted","Insurance Paid","Calculated Penalty","Other Charges Paid";
        }
        key(Key6;"Loan No.","G/L Posting Date")
        {
            SumIndexFields = "Interest Paid","Principal Paid","Penalty Paid";
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        UserSetup.GET(USERID);
        "User ID" := USERID;
        "Responsibility Center" := UserSetup."Default Responsibility Center";
        "Shortcut Dimension 1 Code" := UserSetup."Shortcut Dimension 1 Code";
        "Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
    end;

    var
        UserSetup: Record "91";
}

