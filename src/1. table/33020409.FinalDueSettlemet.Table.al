table 33020409 "Final Due Settlemet"
{

    fields
    {
        field(1; "Emp Settlement No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Emp Settlement No." <> xRec."Emp Settlement No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."Emp Settlement No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Employee Code"; Code[10])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.RESET;
                EmpRec.SETRANGE("No.", "Employee Code");
                IF EmpRec.FINDFIRST THEN BEGIN
                    // EmpRec.CALCFIELDS(EmpRec."Department Name",EmpRec."Branch Name");
                    "Full Name" := EmpRec."Full Name";
                    Designation := EmpRec."Job Title";
                    Department := EmpRec."Department Name";
                    Branch := EmpRec."Branch Name";
                    "Date of Joining" := EmpRec."Employment Date";
                    Address := EmpRec.P_WardNo + ',' + EmpRec.P_VDC_NP + ',' + EmpRec.P_District;
                END;
            end;
        }
        field(3; "Full Name"; Text[30])
        {
        }
        field(4; Designation; Text[30])
        {
        }
        field(5; Department; Text[80])
        {
        }
        field(6; Branch; Text[80])
        {
        }
        field(7; "Date of Joining"; Date)
        {
        }
        field(8; "Date of Release"; Date)
        {
        }
        field(9; Address; Text[80])
        {
        }
        field(10; CD_Department; Code[20])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Department));

            trigger OnValidate()
            begin
                DimensionRec.RESET;
                DimensionRec.SETRANGE(Code, CD_Department);
                IF DimensionRec.FINDFIRST THEN BEGIN
                    "CD_Department Name" := DimensionRec.Description;
                END;
            end;
        }
        field(11; "CD_Department Name"; Text[80])
        {
        }
        field(12; "CD_Employee Code"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.RESET;
                EmpRec.SETRANGE("No.", "CD_Employee Code");
                IF EmpRec.FINDFIRST THEN BEGIN
                    "CD_Employee Name" := EmpRec."Full Name";
                END;
            end;
        }
        field(13; "CD_Employee Name"; Text[80])
        {
        }
        field(15; CD_Due; Option)
        {
            OptionMembers = ,Due,"No Due";

            trigger OnValidate()
            begin
                /*HRPermissionRec.RESET;
                HRPermissionRec.SETRANGE("User ID",USERID);
                IF HRPermissionRec.FINDFIRST THEN BEGIN
                   IF NOT HRPermissionRec."Concerned Department" THEN BEGIN
                       ERROR('You dont have permission');
                       END
                   ELSE IF HRPermissionRec.COUNT =0 THEN   BEGIN
                      ERROR('No Permission');
                      END
                   ELSE      BEGIN
                    "CD_User ID" := USERID;
                    "CD_Time Stamp" := TIME;
                    CD_Date := TODAY;
                                       END;
                
                END;
                       */

            end;
        }
        field(16; "CD_User ID"; Code[30])
        {
        }
        field(17; "CD_Time Stamp"; Time)
        {
        }
        field(18; CD_Date; Date)
        {
        }
        field(19; CD_Remark; Text[100])
        {
        }
        field(20; "S_ Department"; Code[20])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Department));

            trigger OnValidate()
            begin
                DimensionRec.RESET;
                DimensionRec.SETRANGE(Code, "S_ Department");
                IF DimensionRec.FINDFIRST THEN BEGIN
                    "S_Department Name" := DimensionRec.Description;
                END;
            end;
        }
        field(21; "S_Department Name"; Text[80])
        {
        }
        field(22; "S_Employee Code"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.RESET;
                EmpRec.SETRANGE("No.", "S_Employee Code");
                IF EmpRec.FINDFIRST THEN BEGIN
                    "S_Employee Name" := EmpRec."Full Name";
                END;
            end;
        }
        field(23; "S_Employee Name"; Text[100])
        {
        }
        field(25; S_Due; Option)
        {
            OptionMembers = ,Due,"No Due";

            trigger OnValidate()
            begin
                "S_User ID" := USERID;
                "S_Time Stamp" := TIME;
                S_Date := TODAY;
            end;
        }
        field(26; "S_User ID"; Code[30])
        {
        }
        field(27; "S_Time Stamp"; Time)
        {
        }
        field(28; S_Date; Date)
        {
        }
        field(29; S_Remark; Text[100])
        {
        }
        field(30; SMC_Department; Code[20])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Department));

            trigger OnValidate()
            begin
                DimensionRec.RESET;
                DimensionRec.SETRANGE(Code, SMC_Department);
                IF DimensionRec.FINDFIRST THEN BEGIN
                    "SMC_Department Name" := DimensionRec.Description;
                END;
            end;
        }
        field(31; "SMC_Department Name"; Text[100])
        {
        }
        field(32; "SMC_Employee Code"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.RESET;
                EmpRec.SETRANGE("No.", "SMC_Employee Code");
                IF EmpRec.FINDFIRST THEN BEGIN
                    "SMC_Employee Name" := EmpRec."Full Name";
                END;
            end;
        }
        field(33; "SMC_Employee Name"; Text[80])
        {
        }
        field(35; SMC_Due; Option)
        {
            OptionMembers = ,Due,"No Due";

            trigger OnValidate()
            begin
                "SMC_User ID" := USERID;
                "SMC_Time Stamp" := TIME;
                SMC_Date := TODAY;
            end;
        }
        field(36; "SMC_User ID"; Code[30])
        {
        }
        field(37; "SMC_Time Stamp"; Time)
        {
        }
        field(38; SMC_Date; Date)
        {
        }
        field(39; SMC_Remark; Text[100])
        {
        }
        field(40; AD_Department; Code[20])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Department));

            trigger OnValidate()
            begin
                DimensionRec.RESET;
                DimensionRec.SETRANGE(Code, AD_Department);
                IF DimensionRec.FINDFIRST THEN BEGIN
                    "AD_Department Name" := DimensionRec.Description;
                END;
            end;
        }
        field(41; "AD_Department Name"; Text[100])
        {
        }
        field(42; "AD_Employee Code"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.RESET;
                EmpRec.SETRANGE("No.", "AD_Employee Code");
                IF EmpRec.FINDFIRST THEN BEGIN
                    "AD_Employee Name" := EmpRec."Full Name";
                END;
            end;
        }
        field(43; "AD_Employee Name"; Text[80])
        {
        }
        field(45; AD_Due; Option)
        {
            OptionMembers = ,Due,"No Due";

            trigger OnValidate()
            begin
                "AD_User ID" := USERID;
                "AD_Time Stamp" := TIME;
                AD_Date := TODAY;
            end;
        }
        field(46; "AD_User ID"; Code[30])
        {
        }
        field(47; "AD_Time Stamp"; Time)
        {
        }
        field(48; AD_Date; Date)
        {
        }
        field(49; AD_Remark; Text[100])
        {
        }
        field(50; IT_Department; Code[20])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Department));

            trigger OnValidate()
            begin
                DimensionRec.RESET;
                DimensionRec.SETRANGE(Code, IT_Department);
                IF DimensionRec.FINDFIRST THEN BEGIN
                    "IT_Department Name" := DimensionRec.Description;
                END;
            end;
        }
        field(51; "IT_Department Name"; Text[100])
        {
        }
        field(52; "IT_Employee Code"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.RESET;
                EmpRec.SETRANGE("No.", "IT_Employee Code");
                IF EmpRec.FINDFIRST THEN BEGIN
                    "IT_Employee Name" := EmpRec."Full Name";
                END;
            end;
        }
        field(53; "IT_Employee Name"; Text[80])
        {
        }
        field(55; IT_Due; Option)
        {
            OptionMembers = ,Due,"No Due";

            trigger OnValidate()
            begin
                "IT_User ID" := USERID;
                "IT_Time Stamp" := TIME;
                IT_Date := TODAY;
            end;
        }
        field(56; "IT_User ID"; Code[30])
        {
        }
        field(57; "IT_Time Stamp"; Time)
        {
        }
        field(58; IT_Date; Date)
        {
        }
        field(59; IT_Remark; Text[100])
        {
        }
        field(60; ACC_Department; Code[20])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Department));

            trigger OnValidate()
            begin
                DimensionRec.RESET;
                DimensionRec.SETRANGE(Code, ACC_Department);
                IF DimensionRec.FINDFIRST THEN BEGIN
                    "ACC_Department Name" := DimensionRec.Description;
                END;
            end;
        }
        field(61; "ACC_Department Name"; Text[30])
        {
        }
        field(62; "ACC_Employee Code"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.RESET;
                EmpRec.SETRANGE("No.", "ACC_Employee Code");
                IF EmpRec.FINDFIRST THEN BEGIN
                    "ACC_Employee Name" := EmpRec."Full Name";
                END;
            end;
        }
        field(63; "ACC_Employee Name"; Text[50])
        {
        }
        field(64; ACC_Due; Option)
        {
            OptionMembers = ,Due,"No Due";

            trigger OnValidate()
            begin
                "IT_User ID" := USERID;
                "IT_Time Stamp" := TIME;
                IT_Date := TODAY;
            end;
        }
        field(65; "ACC_User ID"; Code[30])
        {
        }
        field(66; "ACC_Time Stamp"; Time)
        {
        }
        field(67; ACC_Date; Date)
        {
        }
        field(68; ACC_Remark; Text[100])
        {
        }
        field(70; "Date of Final Settlement"; Date)
        {
        }
        field(71; "Last Total Amount"; Decimal)
        {
        }
        field(72; Posted; Boolean)
        {
        }
        field(73; "Posted Date"; Date)
        {
        }
        field(74; "No. Series"; Code[20])
        {
        }
        field(75; SMP_Department; Code[20])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Department));

            trigger OnValidate()
            begin
                DimensionRec.RESET;
                DimensionRec.SETRANGE(Code, SMP_Department);
                IF DimensionRec.FINDFIRST THEN BEGIN
                    "SMP_Department Name" := DimensionRec.Description;
                END;
            end;
        }
        field(76; "SMP_Department Name"; Text[30])
        {
        }
        field(77; "SMP_Employee Code"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.RESET;
                EmpRec.SETRANGE("No.", "SMP_Employee Code");
                IF EmpRec.FINDFIRST THEN BEGIN
                    "SMP_Employee Name" := EmpRec."Full Name";
                END;
            end;
        }
        field(78; "SMP_Employee Name"; Text[50])
        {
        }
        field(79; SMP_Due; Option)
        {
            OptionMembers = ,Due,"No Due";

            trigger OnValidate()
            begin
                "SMP_User ID" := USERID;
                "SMP_Time Stamp" := TIME;
                SMP_Date := TODAY;
            end;
        }
        field(80; "SMP_User ID"; Code[30])
        {
        }
        field(81; "SMP_Time Stamp"; Time)
        {
        }
        field(82; SMP_Date; Date)
        {
        }
        field(83; SMP_Remark; Text[100])
        {
        }
        field(84; LS_Department; Code[20])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Department));

            trigger OnValidate()
            begin
                DimensionRec.RESET;
                DimensionRec.SETRANGE(Code, LS_Department);
                IF DimensionRec.FINDFIRST THEN BEGIN
                    "LS_Department Name" := DimensionRec.Description;
                END;
            end;
        }
        field(85; "LS_Department Name"; Text[30])
        {
        }
        field(86; "LS_Employee Code"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.RESET;
                EmpRec.SETRANGE("No.", "LS_Employee Code");
                IF EmpRec.FINDFIRST THEN BEGIN
                    "LS_Employee Name" := EmpRec."Full Name";
                END;
            end;
        }
        field(87; "LS_Employee Name"; Text[50])
        {
        }
        field(88; LS_Due; Option)
        {
            OptionMembers = ,Due,"No Due";

            trigger OnValidate()
            begin
                "LS_User ID" := USERID;
                "LS_Time Stamp" := TIME;
                LS_Date := TODAY;
            end;
        }
        field(89; "LS_User ID"; Code[30])
        {
        }
        field(90; "LS_Time Stamp"; Time)
        {
        }
        field(91; LS_Date; Date)
        {
        }
        field(92; LS_Remark; Text[100])
        {
        }
        field(93; HL_Department; Code[20])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Department));

            trigger OnValidate()
            begin
                DimensionRec.RESET;
                DimensionRec.SETRANGE(Code, HL_Department);
                IF DimensionRec.FINDFIRST THEN BEGIN
                    "HL_Department Name" := DimensionRec.Description;
                END;
            end;
        }
        field(94; "HL_Department Name"; Text[30])
        {
        }
        field(95; "HL_Employee Code"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.RESET;
                EmpRec.SETRANGE("No.", "HL_Employee Code");
                IF EmpRec.FINDFIRST THEN BEGIN
                    "HL_Employee Name" := EmpRec."Full Name";
                END;
            end;
        }
        field(96; "HL_Employee Name"; Text[50])
        {
        }
        field(97; HL_Due; Option)
        {
            OptionMembers = ,Due,"No Due";

            trigger OnValidate()
            begin
                "HL_User ID" := USERID;
                "HL_Time Stamp" := TIME;
                HL_Date := TODAY;
            end;
        }
        field(98; "HL_User ID"; Code[30])
        {
        }
        field(99; "HL_Time Stamp"; Time)
        {
        }
        field(100; HL_Date; Date)
        {
        }
        field(101; HL_Remark; Text[100])
        {
        }
        field(102; VF_Department; Code[20])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Department));

            trigger OnValidate()
            begin
                DimensionRec.RESET;
                DimensionRec.SETRANGE(Code, VF_Department);
                IF DimensionRec.FINDFIRST THEN BEGIN
                    "VF_Department Name" := DimensionRec.Description;
                END;
            end;
        }
        field(103; "VF_Department Name"; Text[30])
        {
        }
        field(104; "VF_Employee Code"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.RESET;
                EmpRec.SETRANGE("No.", "VF_Employee Code");
                IF EmpRec.FINDFIRST THEN BEGIN
                    "VF_Employee Name" := EmpRec."Full Name";
                END;
            end;
        }
        field(105; "VF_Employee Name"; Text[50])
        {
        }
        field(106; VF_Due; Option)
        {
            OptionMembers = ,Due,"No Due";

            trigger OnValidate()
            begin
                "VF_User ID" := USERID;
                "VF_Time Stamp" := TIME;
                VF_Date := TODAY;
            end;
        }
        field(107; "VF_User ID"; Code[30])
        {
        }
        field(108; "VF_Time Stamp"; Time)
        {
        }
        field(109; VF_Date; Date)
        {
        }
        field(110; VF_Remark; Text[100])
        {
        }
        field(111; W_Department; Code[20])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Department));

            trigger OnValidate()
            begin
                DimensionRec.RESET;
                DimensionRec.SETRANGE(Code, W_Department);
                IF DimensionRec.FINDFIRST THEN BEGIN
                    "W_Department Name" := DimensionRec.Description;
                END;
            end;
        }
        field(112; "W_Department Name"; Text[30])
        {
        }
        field(113; "W_Employee Code"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.RESET;
                EmpRec.SETRANGE("No.", "W_Employee Code");
                IF EmpRec.FINDFIRST THEN BEGIN
                    "W_Employee Name" := EmpRec."Full Name";
                END;
            end;
        }
        field(114; "W_Employee Name"; Text[50])
        {
        }
        field(115; W_Due; Option)
        {
            OptionMembers = ,Due,"No Due";

            trigger OnValidate()
            begin
                "W_User ID" := USERID;
                "W_Time Stamp" := TIME;
                W_Date := TODAY;
            end;
        }
        field(116; "W_User ID"; Code[30])
        {
        }
        field(117; "W_Time Stamp"; Time)
        {
        }
        field(118; W_Date; Date)
        {
        }
        field(119; W_Remark; Text[100])
        {
        }
        field(120; "Posted By"; Code[30])
        {
        }
    }

    keys
    {
        key(Key1; "Emp Settlement No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Emp Settlement No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Emp Settlement No.");
            NoSeriesMngt.InitSeries(HRSetup."Emp Settlement No.", xRec."No. Series", 0D, "Emp Settlement No.", "No. Series");
        END;
    end;

    var
        EmpRec: Record "5200";
        DimensionRec: Record "33020337";
        HRSetup: Record "5218";
        NoSeriesMngt: Codeunit "396";
        FinalDueRec: Record "33020409";
        HRPermissionRec: Record "33020304";
        CurrentUserID: Code[20];

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        FinalDueRec := Rec;
        HRSetup.GET;
        HRSetup.TESTFIELD(HRSetup."Emp Settlement No.");
        IF NoSeriesMngt.SelectSeries(HRSetup."Emp Settlement No.", xRec."No. Series", FinalDueRec."No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Emp Settlement No.");
            NoSeriesMngt.SetSeries(FinalDueRec."Emp Settlement No.");
            Rec := FinalDueRec;
            EXIT(TRUE);
        END;
    end;
}

