tableextension 50274 tableextension50274 extends "Human Resources Setup"
{
    fields
    {
        field(50000; "Employee Dimension"; Code[20])
        {
            TableRelation = Dimension;
        }
        field(25006310; "Column Layout Name"; Code[10])
        {
            Caption = 'Column Layout Name';
            TableRelation = "Column Layout Name";
        }
        field(25006320; "Column Layout Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(33020300; "Use Additional Date"; Boolean)
        {
        }
        field(33020301; "Application Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020302; "Automatic Shortlisting"; Boolean)
        {
        }
        field(33020303; "Apply System Restriction"; Boolean)
        {
        }
        field(33020304; "Vacancy Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020305; "Leave Request No."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33020306; "Grace Period"; Time)
        {
        }
        field(33020307; "Office Start Time"; Time)
        {
        }
        field(33020308; "Office End Time"; Time)
        {
        }
        field(33020309; "Maximum Leave Days"; Integer)
        {
        }
        field(33020310; "Training Request No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020311; "Applicant No."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33020312; "Attachment Storage Type"; Option)
        {
            OptionMembers = Embedded,"Disk File";
        }
        field(33020313; "Attachment Storage Location"; Text[250])
        {
        }
        field(33020314; "Incident No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020315; "Appraisal No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020316; "Employee Req. No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020317; "HR Approver Email I"; Text[100])
        {
        }
        field(33020318; "HR Approver Email II"; Text[100])
        {
        }
        field(33020319; "HR Approver Email III"; Text[100])
        {
        }
        field(33020320; "HR Start From Month"; Option)
        {
            OptionMembers = " ",Baisakh,Jestha,Asar,Shrawn,Bhadra,Ashoj,Kartik,Mangsir,Poush,Margh,Falgun,Chaitra;
        }
        field(33020321; "Vacancy Nos. New"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(33020322; "Leave Earn No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020323; "EmpActivity No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020324; "EmpPromotion No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020325; "Assign No."; Code[35])
        {
            TableRelation = "No. Series";
        }
        field(33020326; "Emp Settlement No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020327; "Exit No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020328; "Emp Family No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020329; "Discipline No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020330; "Outsource No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020331; "EmpLoyee Outsource Billing No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020332; "Outsource Employee No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020333; "Internal Applicant No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020334; "Staff Requisition No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020335; "Leave Register"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020336; "ODD/Training/Gatepass No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020337; "Leave Encash/ WriteOff No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020338; "WorkShift No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020339; "Travel order No."; Code[20])
        {
            TableRelation = "No. Series";
        }
    }
}

