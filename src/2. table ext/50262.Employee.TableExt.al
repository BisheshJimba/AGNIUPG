tableextension 50262 tableextension50262 extends Employee
{
    // ->Validation of Payroll Component usage and payroll general setup is disabled = On august-13
    // ->Validation of level and Grade -> "Basic Pay" := BasicWithGrade."Basic Salary" + BasicWithGrade."Additional Value";
    //                                  //total := "basic pay" + "dearness allowance" + "other allowance";
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""No."(Field 1)".


        //Unsupported feature: Property Modification (Data type) on ""Job Title"(Field 6)".

        modify(City)
        {
            TableRelation = IF (Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
        }
        modify("Post Code")
        {
            TableRelation = IF (Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Country/Region Code));
        }

        //Unsupported feature: Property Modification (Data type) on ""Phone No."(Field 13)".


        //Unsupported feature: Property Modification (Name) on ""Mobile Phone No."(Field 14)".


        //Unsupported feature: Property Modification (Data type) on ""Mobile Phone No."(Field 14)".

        modify("E-Mail")
        {

            //Unsupported feature: Property Modification (Name) on ""E-Mail"(Field 15)".

            Caption = 'E-Mail';
        }
        modify(Gender)
        {
            OptionCaption = ' ,Male,Female';

            //Unsupported feature: Property Modification (OptionString) on "Gender(Field 24)".

        }
        modify(Status)
        {
            OptionCaption = ' ,Probation,Confirmed,Suspension,Contract,Left,Retired,Terminated,Trf Sister Concern,As Manager,Trainee,Outsource';

            //Unsupported feature: Property Modification (OptionString) on "Status(Field 31)".

            Description = ' ,Probation,Confirmed,Suspension,Contract,Left,Retired,Terminated,Trf Sister Concern,Outsource';
        }

        //Unsupported feature: Property Modification (Name) on ""Inactive Date"(Field 32)".

        modify("Global Dimension 2 Code")
        {
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2),
                                                          Dimension Value Type=CONST(Standard));
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 39)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Total Absence (Base)"(Field 45)".



        //Unsupported feature: Code Insertion on ""First Name"(Field 2)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            IF "Middle Name" = '' THEN
              "Full Name" :="First Name" +  ' ' + "Last Name"
            ELSE
            "Full Name" :="First Name" + ' ' + "Middle Name" + ' ' + "Last Name";
            //-----@yuran 19-jul-2013 >>
            CreateDimension;
            //-----@yuran 19-jul-2013 <<
            "Payroll %" := 100;
            */
        //end;


        //Unsupported feature: Code Insertion on ""Middle Name"(Field 3)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            IF "Middle Name" = '' THEN
              "Full Name" :="First Name" +  ' ' + "Last Name"
            ELSE
            "Full Name" :="First Name" + ' ' + "Middle Name" + ' ' + "Last Name";
            */
        //end;


        //Unsupported feature: Code Insertion on ""Last Name"(Field 4)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            IF "Middle Name" = '' THEN
              "Full Name" :="First Name" +  ' ' + "Last Name"
            ELSE
            "Full Name" :="First Name" + ' ' + "Middle Name" + ' ' + "Last Name";
            //-----@yuran 19-jul-2013 >>
            CreateDimension;
            //-----@yuran 19-jul-2013 <<
            */
        //end;


        //Unsupported feature: Code Insertion on ""Job Title"(Field 6)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            {
            JobTitleRec.RESET;
            JobTitleRec.SETRANGE(Description,"Job Title");
            IF JobTitleRec.FINDFIRST THEN BEGIN
                 Employee."Job Title code" := JobTitleRec.Code;
            END;
            }
            */
        //end;


        //Unsupported feature: Code Modification on "Status(Field 31).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            EmployeeQualification.SETRANGE("Employee No.","No.");
            EmployeeQualification.MODIFYALL("Employee Status",Status);
            MODIFY;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            EmployeeQualification.SETRANGE("No.","No.");
            EmployeeQualification.MODIFYALL("Employee Status",Status);
            MODIFY;
            */
        //end;

        //Unsupported feature: Property Deletion (CaptionML) on ""Inactive Date"(Field 32)".



        //Unsupported feature: Code Insertion on ""Termination Date"(Field 34)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            IF NOT ((Status = Status ::Left ) OR (Status = Status ::Retired ) OR (Status = Status :: Terminated)) THEN
              ERROR('Status should be Left, Retired or Terminated, to fill Termination Date!');
            */
        //end;
        field(10000;"Bank ID";Text[10])
        {
            Description = 'NCHL-NPI_1.00';

            trigger OnLookup()
            begin
                //NCHL-NPI_1.00 >>
                CompanyInfo.GET;
                IF NOT CompanyInfo."Enable NCHL-NPI Integration" THEN
                  EXIT;

                CIPSWebServiceMgt.GetCIPSBankList;
                CLEAR(CIPSBankList);
                TempCIPSBankAccount.RESET;
                TempCIPSBankAccount.SETCURRENTKEY(Agent, Branch, "Line No.");
                TempCIPSBankAccount.SETASCENDING(Branch, TRUE);
                TempCIPSBankAccount.SETFILTER("End to End ID", 'CIPSBANKLISTS');
                CIPSBankList.SETRECORD(TempCIPSBankAccount);
                CIPSBankList.SETTABLEVIEW(TempCIPSBankAccount);
                CIPSBankList.LOOKUPMODE(TRUE);
                COMMIT();
                IF CIPSBankList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                  CIPSBankList.GETRECORD(TempCIPSBankAccount);
                  "Bank ID" := TempCIPSBankAccount.Agent;
                  "Bank Name" := TempCIPSBankAccount.Name;
                END;
                TempCIPSBankAccount.RESET;
                TempCIPSBankAccount.SETFILTER("End to End ID", 'CIPSBANKLISTS');
                IF TempCIPSBankAccount.FINDFIRST THEN
                  TempCIPSBankAccount.DELETEALL;
                //NCHL-NPI_1.00 <<
            end;
        }
        field(10001;"Bank Branch Name";Text[80])
        {
            Description = 'NCHL-NPI_1.00';
        }
        field(10002;"Bank Branch No.";Text[20])
        {
            Caption = 'Branch ID';
            Description = 'to be used as Branch ID for CIPS Integration,NCHL-NPI_1.00';

            trigger OnLookup()
            begin
                //NCHL-NPI_1.00 >>
                CompanyInfo.GET;
                IF NOT CompanyInfo."Enable NCHL-NPI Integration" THEN
                  EXIT;

                TESTFIELD("Bank ID");
                CIPSWebServiceMgt.GetCIPSBankBranchList("Bank ID");
                CLEAR(CIPSBankList);
                TempCIPSBankAccount.RESET;
                TempCIPSBankAccount.SETCURRENTKEY(Agent,"Line No.");
                TempCIPSBankAccount.SETASCENDING("Line No.", TRUE);
                TempCIPSBankAccount.SETFILTER("End to End ID", 'CIPSBANKLISTS');
                CIPSBankList.SETRECORD(TempCIPSBankAccount);
                CIPSBankList.SETTABLEVIEW(TempCIPSBankAccount);
                CIPSBankList.LOOKUPMODE(TRUE);
                COMMIT();
                IF CIPSBankList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                  CIPSBankList.GETRECORD(TempCIPSBankAccount);
                  "Bank Branch No." := TempCIPSBankAccount.Branch;
                  "Bank Branch Name" := TempCIPSBankAccount.Name;
                END;
                TempCIPSBankAccount.RESET;
                TempCIPSBankAccount.SETFILTER("End to End ID", 'CIPSBANKLISTS');
                IF TempCIPSBankAccount.FINDFIRST THEN
                  TempCIPSBankAccount.DELETEALL ;
                //NCHL-NPI_1.00 <<
            end;
        }
        field(10005;"Bank Name";Text[100])
        {
            Description = 'NCHL-NPI_1.00';
        }
        field(50000;Balance;Decimal)
        {
        }
        field(50010;"Attendance Emp Code";Code[20])
        {
        }
        field(50100;"Signatory Group";Option)
        {
            Description = 'CNY1.0';
            OptionCaption = ' ,A,B';
            OptionMembers = " ",A,B;
        }
        field(50200;"Payroll Period Filter";Date)
        {
            FieldClass = FlowFilter;
        }
        field(50300;"Computer User";Option)
        {
            Description = ',Yes,No';
            OptionCaption = ',Yes,No';
            OptionMembers = ,Yes,No;
        }
        field(50400;"Location Code";Text[30])
        {
        }
        field(50500;"Emergency Contact No.";Text[10])
        {
        }
        field(50600;"Teacher's class";Text[50])
        {
        }
        field(50601;"Last Working Day";Date)
        {
        }
        field(33019810;"Grade Code";Code[20])
        {
            TableRelation = Grades."Grade Code" WHERE (Blocked=CONST(No));
        }
        field(33019811;"Department Code";Code[20])
        {
            TableRelation = "Location Master".Code;

            trigger OnValidate()
            begin
                 MasterRec.RESET;
                 MasterRec.SETRANGE(Code,"Department Code");
                 IF MasterRec.FINDFIRST THEN BEGIN
                  "Department Name" := MasterRec.Description;
                  "Global Dimension 2 Code" := MasterRec."Global Dimension 2";
                 END;
            end;
        }
        field(33019812;"Branch Code";Code[20])
        {
            TableRelation = "Location Master".Code;

            trigger OnValidate()
            begin
                 MasterRec.SETRANGE(Code,"Branch Code");
                 IF MasterRec.FINDFIRST THEN BEGIN
                   "Branch Name" := MasterRec.Description;
                   "Global Dimension 1 Code" := MasterRec."Global Dimension 1";
                 END;
            end;
        }
        field(33019813;"Full Name";Text[150])
        {
            Editable = false;
        }
        field(33019814;"User ID";Code[50])
        {
            TableRelation = "User Setup"."User ID";

            trigger OnLookup()
            var
                LoginMgt: Codeunit "418";
            begin
                //LoginMgt.LookupUserID("User ID");
            end;

            trigger OnValidate()
            var
                LoginMgt: Codeunit "418";
            begin
                //LoginMgt.ValidateUserID("User ID");
            end;
        }
        field(33019815;"Manager ID";Code[50])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                Employee.RESET;
                Employee.SETRANGE(Employee."No.","Manager ID");
                IF Employee.FINDFIRST THEN BEGIN
                   Manager := Employee."Full Name";
                   "First Appraisal ID" := "Manager ID";
                   "First Appraiser" := Employee."Full Name";
                   //"Second Appraisal ID" := Employee."Manager ID";
                   //"Second Appraiser" := Employee.Manager;
                END;
            end;
        }
        field(33020310;"Job Title code";Code[20])
        {
            TableRelation = "Job Title".Code;

            trigger OnValidate()
            begin
                 JobTitleRec.RESET;
                 JobTitleRec.SETRANGE(Code,"Job Title code");
                 IF JobTitleRec.FINDFIRST THEN BEGIN
                  "Job Title" := JobTitleRec.Description;
                END;
            end;
        }
        field(33020311;"Work Shift Code";Code[20])
        {
            TableRelation = "Work Shift Master".Code;

            trigger OnValidate()
            begin
                CALCFIELDS("Work Shift Description");
            end;
        }
        field(33020312;"Work Shift Description";Text[100])
        {
            CalcFormula = Lookup("Work Shift Master".Description WHERE (Code=FIELD(Work Shift Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020313;"Shift Start Time";Time)
        {
        }
        field(33020314;"Shift End Time";Time)
        {
        }
        field(33020315;"Exam Department Code";Code[20])
        {
            TableRelation = "Exam Department"."Exam Department Code";

            trigger OnValidate()
            begin
                // ExamDepartment.RESET;
                // ExamDepartment.SETRANGE("Exam Department Code","Exam Department Code");
                // IF ExamDepartment.FINDFIRST THEN BEGIN
                //  "Exam Department" := ExamDepartment."Exam Department Descrition";
                // END;
            end;
        }
        field(33020316;"Exam Department";Text[50])
        {
        }
        field(33020318;Blocked;Boolean)
        {
        }
        field(33020320;"District Code";Code[10])
        {
            SQLDataType = Integer;
            TableRelation = District.Code;

            trigger OnValidate()
            begin
                CALCFIELDS("District Name");
            end;
        }
        field(33020321;"District Name";Text[80])
        {
            CalcFormula = Lookup(District.Name WHERE (Code=FIELD(District Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020322;"VDC Code";Code[10])
        {
            SQLDataType = Integer;
            TableRelation = VDC.Code WHERE (District Code=FIELD(District Code));

            trigger OnValidate()
            begin
                CALCFIELDS("VDC Name");
            end;
        }
        field(33020323;"VDC Name";Text[80])
        {
            CalcFormula = Lookup(VDC.Name WHERE (Code=FIELD(VDC Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020324;"Department Name";Text[80])
        {
            FieldClass = Normal;
        }
        field(33020325;"Internal File No.";Code[30])
        {
        }
        field(33020326;Religion;Text[50])
        {
        }
        field(33020327;Nationality;Option)
        {
            Description = ' ,Nepali,Indian';
            OptionCaption = ' ,Nepali,Indian';
            OptionMembers = " ",Nepali,Indian;
        }
        field(33020328;"Marital Status";Option)
        {
            OptionMembers = " ",Single,Married;
        }
        field(33020329;"Driving License";Boolean)
        {
        }
        field(33020330;"Driving License No.";Text[30])
        {
        }
        field(33020331;Foreign;Boolean)
        {
        }
        field(33020332;"Passport No.";Text[80])
        {
        }
        field(33020333;"Passport Issue Date";Date)
        {
        }
        field(33020334;"Passport Expiry Date";Date)
        {
        }
        field(33020335;"Passport Issue Place";Text[30])
        {
        }
        field(33020336;"Visa Type";Option)
        {
            OptionCaption = ' ,Visit,Sponsered by Employer,Sponsered by Company,Husband Visa,Other';
            OptionMembers = " ",Visit,"Sponsered by Employer","Sponsered by Company","Husband Visa",Other;
        }
        field(33020337;"Work Permit No.";Text[30])
        {
        }
        field(33020338;"Work Permit Expiry Date";Date)
        {
        }
        field(33020339;"Residency No.";Text[30])
        {
        }
        field(33020340;Insurance;Boolean)
        {
        }
        field(33020341;"Insurance Policy No.";Text[50])
        {
        }
        field(33020342;Designation;Text[50])
        {
        }
        field(33020343;"Special Case";Boolean)
        {
        }
        field(33020344;"Grace Period";Time)
        {
        }
        field(33020345;"Employment Type";Option)
        {
            OptionMembers = " ","Full Time","Part Time",Contractual;
        }
        field(33020347;"Applicant No.";Code[20])
        {
            Description = '//Convert into employee from Vacancy';
            TableRelation = Application.No.;
        }
        field(33020348;"Father Name";Text[50])
        {
        }
        field(33020349;"GrandFather Name";Text[50])
        {
        }
        field(33020350;"Citizenship No.";Text[30])
        {
        }
        field(33020351;"Issue Office";Text[30])
        {
        }
        field(33020352;"Issue District";Text[30])
        {
        }
        field(33020353;P_WardNo;Code[5])
        {
        }
        field(33020354;P_VDC_NP;Text[30])
        {
        }
        field(33020355;P_District;Text[30])
        {
        }
        field(33020356;P_Zone;Text[30])
        {
        }
        field(33020357;T_WardNo;Code[5])
        {
        }
        field(33020358;T_VDC_NP;Text[30])
        {
        }
        field(33020359;T_District;Text[30])
        {
        }
        field(33020360;T_Zone;Text[30])
        {
        }
        field(33020361;"Blood Group";Option)
        {
            Description = ' ,A+,A-,B+,B-,AB+,AB-,O+,O-';
            OptionCaption = ' ,A+,A-,B+,B-,AB+,AB-,O+,O-';
            OptionMembers = " ","A+","A-","B+","B-","AB+","AB-","O+","O-";
        }
        field(33020362;"Medical Certificate No.";Text[30])
        {
        }
        field(33020363;"First Appraisal ID";Code[30])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                Employee.RESET;
                Employee.SETRANGE(Employee."No.","First Appraisal ID");
                IF Employee.FINDFIRST THEN BEGIN
                   "First Appraiser" := Employee."Full Name";
                END;
            end;
        }
        field(33020364;"Second Appraisal ID";Code[30])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                Employee.RESET;
                Employee.SETRANGE(Employee."No.","Second Appraisal ID");
                IF Employee.FINDFIRST THEN BEGIN
                   "Second Appraiser" := Employee."Full Name";
                END;
            end;
        }
        field(33020365;"First Appraised";Boolean)
        {
            CalcFormula = Lookup(Appraisal.IsAppraised1 WHERE (Employee Code=FIELD(No.)));
            FieldClass = FlowField;
        }
        field(33020366;"Second Appraised";Boolean)
        {
            CalcFormula = Lookup(Appraisal.IsAppraised2 WHERE (Employee Code=FIELD(No.)));
            FieldClass = FlowField;
        }
        field(33020367;"Branch Name";Text[50])
        {
            FieldClass = Normal;
        }
        field(33020368;Manager;Text[150])
        {
            FieldClass = Normal;
        }
        field(33020369;"First Appraiser";Text[90])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE (No.=FIELD(First Appraisal ID)));
            FieldClass = FlowField;
        }
        field(33020370;"Second Appraiser";Text[90])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE (No.=FIELD(Second Appraisal ID)));
            FieldClass = FlowField;
        }
        field(33020371;"CIT No.";Text[50])
        {
        }
        field(33020372;"PAN No.";Text[50])
        {
        }
        field(33020373;"PF No.";Text[50])
        {
        }
        field(33020374;"Mobile Phone No.2";Text[30])
        {
        }
        field(33020375;"Manager Department Code";Code[20])
        {
        }
        field(33020376;"Manager's Designation";Option)
        {
            Description = ' ,HOD,Reporting 1,Reporting 2,Reporting 3,Reporting 4,Reporting 5,Reporting 6,Reporting 7,Reporting 8,Reporting 9,Reporting 10,VP,GM,CEO,EC,Reporting 11,Reporting 12,Reporting 13,Reporting 14,Reporting 15';
            OptionCaption = ' ,HOD,Reporting 1,Reporting 2,Reporting 3,Reporting 4,Reporting 5,Reporting 6,Reporting 7,Reporting 8,Reporting 9,Reporting 10,VP,GM,CEO,EC,Reporting 11,Reporting 12,Reporting 13,Reporting 14,Reporting 15';
            OptionMembers = " ",HOD,"Reporting 1","Reporting 2","Reporting 3","Reporting 4","Reporting 5","Reporting 6","Reporting 7","Reporting 8","Reporting 9","Reporting 10",VP,GM,CEO,EC,"Reporting 11","Reporting 12","Reporting 13","Reporting 14","Reporting 15";
        }
        field(33020377;"Exam Level";Code[30])
        {
            TableRelation = "Exam Level Master".Code;
        }
        field(33020379;"Bank Account No.";Text[30])
        {
        }
        field(33020380;"Division Code";Code[10])
        {
            TableRelation = "Location Master".Code WHERE (Type=CONST(Division));

            trigger OnValidate()
            begin
                // MasterRec.RESET;
                // MasterRec.SETRANGE(Code,"Division Code");
                // IF MasterRec.FINDFIRST THEN
                //  Division := MasterRec.Description;
                // IF MasterRec.COUNT = 0 THEN
                //  Division := '';
            end;
        }
        field(33020381;Division;Text[50])
        {
        }
        field(33020382;"Workstation Code";Code[10])
        {
            TableRelation = "Location Master".Code WHERE (Type=CONST(Workstation));

            trigger OnValidate()
            begin
                // MasterRec.RESET;
                // MasterRec.SETRANGE(Code,"Workstation Code");
                // IF MasterRec.FINDFIRST THEN
                //  Workstation := MasterRec.Description;
                // IF MasterRec.COUNT = 0 THEN
                //  Workstation := '';
            end;
        }
        field(33020383;Workstation;Text[50])
        {
        }
        field(33020384;Company;Text[30])
        {
            TableRelation = Company.Name;
        }
        field(33020385;"Restrict Leave Earn";Boolean)
        {
            Description = 'true if employee is absent without information, processed when attendance is posted';

            trigger OnValidate()
            begin
                "Leave Restrited Date" := TODAY;
            end;
        }
        field(33020386;"Leave Restrited Date";Date)
        {
        }
        field(33020387;"Basic Pay";Decimal)
        {

            trigger OnValidate()
            begin
                Total := "Basic Pay" + "Dearness Allowance" + "Other Allowance";
            end;
        }
        field(33020388;"Dearness Allowance";Decimal)
        {

            trigger OnValidate()
            begin
                Total := "Basic Pay" + "Dearness Allowance" + "Other Allowance";
            end;
        }
        field(33020389;"Other Allowance";Decimal)
        {

            trigger OnValidate()
            begin
                Total := "Basic Pay" + "Dearness Allowance" + "Other Allowance";
            end;
        }
        field(33020390;Total;Decimal)
        {

            trigger OnValidate()
            begin
                Total := "Basic Pay" + "Dearness Allowance" + "Other Allowance";
            end;
        }
        field(33020500;Level;Code[20])
        {
            TableRelation = "Salary Level";

            trigger OnValidate()
            begin
                IF (Rec.Level <> xRec.Level) THEN
                  InsertSalaryLog;
            end;
        }
        field(33020501;Grade;Code[20])
        {
            TableRelation = "Salary Grade";

            trigger OnValidate()
            begin
                IF (Rec.Grade <> xRec.Grade) THEN
                  InsertSalaryLog;
            end;
        }
        field(33020502;"Tax Code";Code[20])
        {
            TableRelation = "Tax Setup Header";
        }
        field(33020503;"Premium of Life Insurance";Decimal)
        {

            trigger OnValidate()
            begin
                //HRPermission.GET(USERID);
                //IF NOT (HRPermission."HR Admin") OR (HRPermission."Account Department") THEN
                //ERROR('You do not have permission to edit this field. Permission given to HR Admin and Account Department.');
            end;
        }
        field(33020504;"PF Balance";Decimal)
        {
            CalcFormula = Sum("Salary Ledger Entry"."Total Employer Contribution" WHERE (Employee Code=FIELD(No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020505;"CIT Balance";Decimal)
        {
            Editable = false;
        }
        field(33020506;"Tax Balance";Decimal)
        {
            CalcFormula = Sum("Salary Ledger Entry"."Tax Paid" WHERE (Employee Code=FIELD(No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020507;"Donation Amount";Decimal)
        {
        }
        field(33020508;"Tax on First Account";Decimal)
        {
            CalcFormula = Sum("Posted Salary Line"."Tax Paid on First Account" WHERE (Employee No.=FIELD(No.),
                                                                                      From Date=FIELD(Payroll Period Filter)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020509;"Tax on Second Account";Decimal)
        {
            CalcFormula = Sum("Posted Salary Line"."Tax Paid on Second Account" WHERE (Employee No.=FIELD(No.),
                                                                                       From Date=FIELD(Payroll Period Filter)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020510;Signature;BLOB)
        {
            SubType = Bitmap;
        }
        field(33020511;"Repair & Maintenance Amt";Decimal)
        {
        }
        field(33020512;"Monthly Fuel (Ltr)";Decimal)
        {
        }
        field(33020513;"Re-Appointment Date";Date)
        {
        }
        field(33020514;"Gratuity %";Decimal)
        {
        }
        field(33020515;"Certificate of origin";Boolean)
        {
            Description = 'for name display in certificate of origin report';
        }
        field(33020516;Saved;Boolean)
        {
        }
        field(33020517;"Minimum Education";Text[100])
        {
        }
        field(33020518;Cheque;Boolean)
        {
        }
        field(33020519;"Payroll %";Decimal)
        {
            Description = 'calculation enhancement regarding lockdown salary percentwise';
        }
        field(33020520;"Gratuity No.";Text[50])
        {
        }
        field(33020521;"Is Traning Manager";Boolean)
        {
        }
        field(33020522;"Resignation Date";Date)
        {
        }
        field(33020523;"Clearancee Date";Date)
        {
        }
        field(33020524;"Resignation Status";Option)
        {
            OptionCaption = ' ,HOD Approva Pending,Admin Pending,Account Pending,HR Experience Letter Pending,Closed';
            OptionMembers = " ","HOD Approva Pending","Admin Pending","Account Pending","HR Experience Letter Pending",Closed;
        }
        field(33020525;"Is Employee Req Manager";Boolean)
        {
        }
        field(33020526;"Applicant From Interview";Boolean)
        {
        }
        field(33020527;"Premium of Health Insurance";Decimal)
        {
        }
        field(33020528;"Premium of Building Insurance";Decimal)
        {
        }
        field(33020529;"Amount of Medical Tax";Decimal)
        {
        }
    }
    keys
    {
        key(Key1;"Full Name","Job Title code")
        {
        }
        key(Key2;"User ID")
        {
        }
    }


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        AlternativeAddr.SETRANGE("Employee No.","No.");
        AlternativeAddr.DELETEALL;

        EmployeeQualification.SETRANGE("Employee No.","No.");
        EmployeeQualification.DELETEALL;

        Relative.SETRANGE("Employee No.","No.");
        #8..19
        HumanResComment.DELETEALL;

        DimMgt.DeleteDefaultDim(DATABASE::Employee,"No.");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..3
        EmployeeQualification.SETRANGE("No.","No.");
        #5..22
        */
    //end;


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF "No." = '' THEN BEGIN
          HumanResSetup.GET;
          HumanResSetup.TESTFIELD("Employee Nos.");
          NoSeriesMgt.InitSeries(HumanResSetup."Employee Nos.",xRec."No. Series",0D,"No.","No. Series");
        END;

        DimMgt.UpdateDefaultDim(
          DATABASE::Employee,"No.",
          "Global Dimension 1 Code","Global Dimension 2 Code");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..5
        //--------@yuran 19-jul-2013 Syncs No. Series in all companies>>
        AgniMgt.SyncMasterData(DATABASE::Employee,"No.","No. Series");
        //--------@yuran 19-jul-2013 Syncs No. Series in all companies<<
        #6..9
        */
    //end;


    //Unsupported feature: Code Modification on "OnModify".

    //trigger OnModify()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        "Last Date Modified" := TODAY;
        IF Res.READPERMISSION THEN
          EmployeeResUpdate.HumanResToRes(xRec,Rec);
        IF SalespersonPurchaser.READPERMISSION THEN
          EmployeeSalespersonUpdate.HumanResToSalesPerson(xRec,Rec);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..5
        IF Saved THEN BEGIN
          UserSetup.GET(USERID); //MIN 5/2/2019
          IF NOT UserSetup."Can Edit Employee Card" THEN
           ERROR(NoModifyPermissionErr);
        END;
        */
    //end;

    procedure InsertSalaryLog()
    var
        SalaryLog: Record "33020519";
        BasicWithGrade: Record "33020502";
        ComponentUsage: Record "33020504";
        PGSetup: Record "33020507";
    begin
        IF (Level <> '') AND (Grade <> '') THEN BEGIN
          BasicWithGrade.GET(Level,Grade);
          SalaryLog.RESET;
          SalaryLog.SETRANGE("Employee No.","No.");
          SalaryLog.SETRANGE("Effective Date",TODAY);
          IF SalaryLog.FINDFIRST THEN BEGIN
            SalaryLog.Level := Level;
            SalaryLog.Grade := Grade;
            SalaryLog."Basic with Grade" := (BasicWithGrade."Basic Salary"+ BasicWithGrade."Additional Value");
        
            //on 15-august-2013<jm>
            "Basic Pay" := BasicWithGrade."Basic Salary"+ BasicWithGrade."Additional Value";
        
             PayrollCompUsage.RESET;
             PayrollCompUsage.SETRANGE("Employee No.","No.");
             IF PayrollCompUsage.FINDFIRST THEN BEGIN
                CASE PayrollCompUsage."Payroll Component Code"  OF
                      'DEARNESS ALLOWANCE' :
                           "Dearness Allowance" := PayrollCompUsage.Amount;
                       ELSE
                            "Other Allowance" := 0; //
                      END
            END;
            SalaryLog.MODIFY;
          END
          ELSE BEGIN
            CLEAR(SalaryLog);
            SalaryLog.INIT;
            SalaryLog."Employee No." := "No.";
            SalaryLog."Effective Date" := TODAY;
            SalaryLog.Level := Level;
            SalaryLog.Grade := Grade;
            SalaryLog."Basic with Grade" := (BasicWithGrade."Basic Salary"+ BasicWithGrade."Additional Value");
            "Basic Pay" := BasicWithGrade."Basic Salary"+ BasicWithGrade."Additional Value";  //on 15-august-2013<jm>
            SalaryLog.INSERT;
          END;
        END;
        
        /*
        PGSetup.GET;
        PGSetup.TESTFIELD("Leave Deduction Component");
        ComponentUsage.RESET;
        ComponentUsage.SETRANGE("Employee No.","No.");
        ComponentUsage.SETRANGE("Payroll Component Code",PGSetup."Leave Deduction Component");
        IF NOT ComponentUsage.FINDFIRST THEN BEGIN
          ComponentUsage.INIT;
          ComponentUsage.VALIDATE("Employee No.","No.");
          ComponentUsage.VALIDATE("Payroll Component Code",PGSetup."Leave Deduction Component");
          ComponentUsage.INSERT;
        END;
        */

    end;

    procedure CreateDimension()
    var
        DimValue: Record "349";
    begin
        //------------@yuran 19-jul-2013 >>

        HumanResSetup.GET;
        HumanResSetup.TESTFIELD("Employee Dimension");
        DimValue.RESET;
        DimValue.SETRANGE("Dimension Code",HumanResSetup."Employee Dimension");
        DimValue.SETRANGE(Code,"No.");
        IF NOT DimValue.FINDFIRST THEN BEGIN
          DimValue.LOCKTABLE;
          DimValue.INIT;
          DimValue.VALIDATE("Dimension Code",HumanResSetup."Employee Dimension");
          DimValue.VALIDATE(Code,"No.");
          DimValue.VALIDATE(Name,COPYSTR(("First Name" + ' ' + "Last Name"),1,50));
          DimValue.INSERT(TRUE);
        END ELSE BEGIN
          IF DimValue.Name <> ("First Name" + ' ' + "Last Name") THEN BEGIN
            DimValue.VALIDATE(Name,COPYSTR(("First Name" + ' ' + "Last Name"),1,50));
            DimValue.MODIFY;
          END;
        END;
        //SyncDimension(HumanResSetup."Employee Dimension","No.",COPYSTR(("First Name" + ' ' + "Last Name"),1,50)); // ** MIN 5/15/2019 comment for no need to flow employee dimension values in all companies.
        //------------@yuran 19-jul-2013 <<
    end;

    procedure SyncDimension(DimensionCode: Code[20];"Code": Code[20];Name: Code[50])
    var
        RecDimValue: Record "349";
        CompanyRec: Record "2000000006";
    begin
        CompanyRec.RESET;
        CompanyRec.SETFILTER(Name,'<>%1',COMPANYNAME);
        IF CompanyRec.FINDSET THEN REPEAT
          HumanResSetup.CHANGECOMPANY(CompanyRec.Name);
          IF HumanResSetup.GET THEN BEGIN
            IF HumanResSetup."Employee Dimension" = DimensionCode THEN BEGIN
              RecDimValue.CHANGECOMPANY(CompanyRec.Name);
              RecDimValue.RESET;
              RecDimValue.SETRANGE("Dimension Code", DimensionCode);
              RecDimValue.SETRANGE(Code,Code);
              IF NOT RecDimValue.FINDLAST THEN BEGIN
                RecDimValue.LOCKTABLE;
                RecDimValue.INIT;
                RecDimValue.VALIDATE("Dimension Code",DimensionCode);
                RecDimValue.VALIDATE(Code,Code);
                RecDimValue.VALIDATE(Name,Name);
                RecDimValue.INSERT(TRUE);
              END ELSE BEGIN
                IF RecDimValue.Name <> Name THEN BEGIN
                  RecDimValue.VALIDATE(Name,Name);
                  RecDimValue.MODIFY;
                END;
              END;
             END;
          END;
          CLEAR(RecDimValue);
          CLEAR(HumanResSetup);
        UNTIL CompanyRec.NEXT = 0;
    end;

    procedure setApprisalType(ApprisalType_: Option " ",Self,Manager,"Manager 360")
    begin
        ApprisalType := ApprisalType_;
    end;

    //Unsupported feature: Property Modification (Fields) on "DropDown(FieldGroup 1)".


    var
        JobTitleRec: Record "33020325";
        MasterRec: Record "33020337";
        ExamDepartment: Record "33020320";
        DimensionValue: Record "349";
        AgniMgt: Codeunit "50000";
        PayrollCompUsage: Record "33020504";
        HRPermission: Record "33020304";
        NoModifyPermissionErr: Label 'You do not have permission to modify employee card.';
        UserSetup: Record "91";
        "--NCHL-NPI_1.00": Integer;
        CompanyInfo: Record "79";
        CIPSWebServiceMgt: Codeunit "33019811";
        CIPSBankList: Page "33019815";
                          TempCIPSBankAccount: Record "33019814";
                          ApprisalType: Option " ",Self,Manager,"Manager 360";
}

