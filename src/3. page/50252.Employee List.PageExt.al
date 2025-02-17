pageextension 50252 pageextension50252 extends "Employee List"
{

    //Unsupported feature: Property Insertion (DeleteAllowed) on ""Employee List"(Page 5201)".

    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "Control 28".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 30".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 72".

        modify("Control 12")
        {
            Visible = false;
        }
        addafter("Control 2")
        {
            field("Attendance Emp Code"; "Attendance Emp Code")
            {
            }
        }
        addafter("Control 10")
        {
            field("Department Code"; "Department Code")
            {
            }
            field("Department Name"; "Department Name")
            {
            }
            field("Branch Code"; "Branch Code")
            {
            }
            field("Branch Name"; "Branch Name")
            {
            }
            field(Status; Rec.Status)
            {
            }
            field("Grade Code"; "Grade Code")
            {
            }
            field("Company E-Mail"; Rec."Company E-Mail")
            {
            }
            field("User ID"; "User ID")
            {
            }
            field("Exam Level"; "Exam Level")
            {
            }
            field("Exam Department Code"; "Exam Department Code")
            {
            }
            field("Exam Department"; "Exam Department")
            {
            }
            field("Full Name"; "Full Name")
            {
            }
            field("Birth Date"; Rec."Birth Date")
            {
            }
            field("Employment Date"; Rec."Employment Date")
            {
            }
            field("Confirmation Date"; "Confirmation Date")
            {
            }
            field("Termination Date"; Rec."Termination Date")
            {
            }
            field(Nationality; Nationality)
            {
            }
            field("Marital Status"; "Marital Status")
            {
            }
            field("Father Name"; "Father Name")
            {
            }
            field("GrandFather Name"; "GrandFather Name")
            {
            }
            field("Citizenship No."; "Citizenship No.")
            {
            }
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
            }
            field(Gender; Rec.Gender)
            {
            }
            field(P_WardNo; P_WardNo)
            {
            }
            field(P_VDC_NP; P_VDC_NP)
            {
            }
            field(P_District; P_District)
            {
            }
            field("Blood Group"; "Blood Group")
            {
            }
            field("Medical Certificate No."; "Medical Certificate No.")
            {
            }
            field("Manager Department Code"; "Manager Department Code")
            {
            }
            field("Manager's Designation"; "Manager's Designation")
            {
            }
            field(Manager; Manager)
            {
            }
            field("First Appraiser"; "First Appraiser")
            {
            }
            field("Second Appraiser"; "Second Appraiser")
            {
            }
            field("CIT No."; "CIT No.")
            {
            }
            field(Level; Level)
            {
            }
            field("PAN No."; "PAN No.")
            {
            }
            field("PF No."; "PF No.")
            {
            }
        }
        addafter("Control 72")
        {
            field("Teacher's class"; "Teacher's class")
            {
            }
        }
        addafter("Control 14")
        {
            field("Resignation Status"; "Resignation Status")
            {
            }
            field("Clearancee Date"; "Clearancee Date")
            {
            }
            field("Resignation Date"; "Resignation Date")
            {
            }
            field("Gratuity No."; "Gratuity No.")
            {
            }
        }
    }
    actions
    {
        modify("Action 1900000003")
        {
            Visible = false;
        }
        modify("Action 33")
        {
            Visible = false;
        }
        modify("Action 43")
        {
            Visible = false;
        }
        modify("Action 20")
        {
            Visible = false;
        }
        modify("Action 184")
        {
            Visible = false;
        }
        modify("Action 19")
        {
            Visible = false;
        }
        modify("Action 44")
        {
            Visible = false;
        }
        modify(AlternativeAddresses)
        {
            Visible = false;
        }
        modify("Action 46")
        {
            Visible = false;
        }
        modify("Action 47")
        {
            Visible = false;
        }
        modify("Action 48")
        {
            Visible = false;
        }
        modify("Action 49")
        {
            Visible = false;
        }
        modify("Action 50")
        {
            Visible = false;
        }
        modify("Action 51")
        {
            Visible = false;
        }
        modify("Action 54")
        {
            Visible = false;
        }
        modify("Action 55")
        {
            Visible = false;
        }
        modify("Action 56")
        {
            Visible = false;
        }
        modify("Action 57")
        {
            Visible = false;
        }
        modify("Action 58")
        {
            Visible = false;
        }
    }

    var
        LeaveEarn: Record "33020398";
        PostLeaveRequest: Record "33020344";
        LeaveAccount: Record "33020370";
        EmpRec: Record "5200";
}

