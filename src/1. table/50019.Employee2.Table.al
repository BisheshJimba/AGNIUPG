table 50019 "Employee-2"
{
    Caption = 'Employee';
    DataCaptionFields = "No.", "First Name", "Middle Name", "Last Name";
    DataPerCompany = false;
    DrillDownPageID = 5201;
    LookupPageID = 5201;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "First Name"; Text[30])
        {
            Caption = 'First Name';
        }
        field(3; "Middle Name"; Text[30])
        {
            Caption = 'Middle Name';
        }
        field(4; "Last Name"; Text[30])
        {
            Caption = 'Last Name';
        }
        field(5; Initials; Text[30])
        {
            Caption = 'Initials';
        }
        field(6; "Job Title"; Text[100])
        {
            Caption = 'Job Title';
        }
        field(7; "Search Name"; Code[30])
        {
            Caption = 'Search Name';
        }
        field(8; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(9; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(10; City; Text[30])
        {
            Caption = 'City';
        }
        field(11; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(12; County; Text[30])
        {
            Caption = 'County';
        }
        field(13; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(14; "Mobile Phone No.1"; Text[30])
        {
            Caption = 'Mobile Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(15; "Personal E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(16; "Alt. Address Code"; Code[10])
        {
            Caption = 'Alt. Address Code';
            TableRelation = "Alternative Address".Code WHERE("Employee No." = FIELD("No."));
        }
        field(17; "Alt. Address Start Date"; Date)
        {
            Caption = 'Alt. Address Start Date';
        }
        field(18; "Alt. Address End Date"; Date)
        {
            Caption = 'Alt. Address End Date';
        }
        field(19; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(20; "Birth Date"; Date)
        {
            Caption = 'Birth Date';
        }
        field(21; "Social Security No."; Text[30])
        {
            Caption = 'Social Security No.';
        }
        field(22; "Union Code"; Code[10])
        {
            Caption = 'Union Code';
            TableRelation = Union;
        }
        field(23; "Union Membership No."; Text[30])
        {
            Caption = 'Union Membership No.';
        }
        field(24; Gender; Option)
        {
            Caption = 'Gender';
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(25; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(26; "Manager No."; Code[20])
        {
            Caption = 'Manager No.';
            TableRelation = Employee;
        }
        field(27; "Emplymt. Contract Code"; Code[10])
        {
            Caption = 'Emplymt. Contract Code';
            TableRelation = "Employment Contract";
        }
        field(28; "Statistics Group Code"; Code[10])
        {
            Caption = 'Statistics Group Code';
            TableRelation = "Employee Statistics Group";
        }
        field(29; "Employment Date"; Date)
        {
            Caption = 'Employment Date';
        }
        field(31; Status; Option)
        {
            Caption = 'Status';
            Description = ' ,Probation,Confirmed,Suspension,Contract,Left,Retired,Terminated,Trf Sister Concern';
            OptionCaption = ' ,Probation,Confirmed,Suspension,Contract,Left,Retired,Terminated,Trf Sister Concern';
            OptionMembers = " ",Probation,Confirmed,Suspension,Contract,Left,Retired,Terminated,"Trf Sister Concern";
        }
        field(32; "Confirmation Date"; Date)
        {
        }
        field(33; "Cause of Inactivity Code"; Code[10])
        {
            Caption = 'Cause of Inactivity Code';
            TableRelation = "Cause of Inactivity";
        }
        field(34; "Termination Date"; Date)
        {
            Caption = 'Termination Date';
        }
        field(35; "Grounds for Term. Code"; Code[10])
        {
            Caption = 'Grounds for Term. Code';
            TableRelation = "Grounds for Termination";
        }
        field(36; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(37; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(38; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource WHERE(Type = CONST(Person));
        }
        field(39; Comment; Boolean)
        {
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Exist("Human Resource Comment Line" WHERE("Table Name" = CONST(Employee),
                                                                     "No." = FIELD("No.")));
        }
        field(40; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(41; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(42; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(43; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(44; "Cause of Absence Filter"; Code[10])
        {
            Caption = 'Cause of Absence Filter';
            FieldClass = FlowFilter;
            TableRelation = "Cause of Absence";
        }
        field(45; "Total Absence (Base)"; Decimal)
        {
            Caption = 'Total Absence (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Employee Absence"."Quantity (Base)" WHERE("Employee No." = FIELD("No."),
                                                                          "Cause of Absence Code" = FIELD("Cause of Absence Filter"),
                                                                          "From Date" = FIELD("Date Filter")));
        }
        field(46; Extension; Text[30])
        {
            Caption = 'Extension';
        }
        field(47; "Employee No. Filter"; Code[20])
        {
            Caption = 'Employee No. Filter';
            FieldClass = FlowFilter;
            TableRelation = Employee;
        }
        field(48; Pager; Text[30])
        {
            Caption = 'Pager';
        }
        field(49; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
        }
        field(50; "Company E-Mail"; Text[80])
        {
            Caption = 'Company E-Mail';
        }
        field(51; Title; Text[30])
        {
            Caption = 'Title';
        }
        field(52; "Salespers./Purch. Code"; Code[10])
        {
            Caption = 'Salespers./Purch. Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(53; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(50000; Balance; Decimal)
        {
        }
        field(50100; "Signatory Group"; Option)
        {
            Description = 'CNY1.0';
            OptionCaption = ' ,A,B';
            OptionMembers = " ",A,B;
        }
        field(33019810; "Grade Code"; Code[20])
        {
            TableRelation = Grades."Grade Code" WHERE(Blocked = const(false));
        }
        field(33019811; "Department Code"; Code[20])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Department),
                                                          Blocked = CONST(false));
        }
        field(33019812; Branch; Code[20])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Branch),
                                                          Blocked = CONST(false));
        }
        field(33019813; "Full Name"; Text[150])
        {
        }
        field(33019814; "User ID"; Code[50])
        {
            TableRelation = "User Setup"."User ID";

            trigger OnLookup()
            var
                LoginMgt: Codeunit "User Management";
            begin
            end;

            trigger OnValidate()
            var
                LoginMgt: Codeunit "User Management";
            begin
            end;
        }
        field(33019815; "Manager ID"; Code[20])
        {
            FieldClass = Normal;
            TableRelation = Employee."No.";
        }
        field(33020310; "Job Title code"; Code[20])
        {
            TableRelation = "Job Title".Code;
        }
        field(33020311; "Work Shift Code"; Code[20])
        {
            TableRelation = "Work Shift Master".Code;
        }
        field(33020312; "Work Shift Description"; Text[100])
        {
            CalcFormula = Lookup("Work Shift Master".Description WHERE(Code = FIELD("Work Shift Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020313; "Shift Start Time"; Time)
        {
        }
        field(33020314; "Shift End Time"; Time)
        {
        }
        field(33020315; "Exam Department Code"; Code[20])
        {
            TableRelation = "Exam Department"."Exam Department Code";
        }
        field(33020316; "Exam Department"; Text[50])
        {
        }
        field(33020318; Blocked; Boolean)
        {
        }
        field(33020320; "District Code"; Code[10])
        {
            SQLDataType = Integer;
            TableRelation = District.Code;
        }
        field(33020321; "District Name"; Text[80])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup(District.Name WHERE(Code = FIELD("District Code")));
        }
        field(33020322; "VDC Code"; Code[10])
        {
            SQLDataType = Integer;
            TableRelation = VDC.Code WHERE("District Code" = FIELD("District Code"));
        }
        field(33020323; "VDC Name"; Text[100])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup(VDC.Name WHERE(Code = FIELD("VDC Code")));
        }
        field(33020324; "Department Name"; Text[80])
        {
            FieldClass = Normal;
        }
        field(33020325; "Internal File No."; Code[30])
        {
        }
        field(33020326; Religion; Text[50])
        {
        }
        field(33020327; Nationality; Option)
        {
            Description = ' ,Nepali,Indian';
            OptionCaption = ' ,Nepali,Indian';
            OptionMembers = " ",Nepali,Indian;
        }
        field(33020328; "Marital Status"; Option)
        {
            OptionMembers = " ",Single,Married;
        }
        field(33020329; "Driving License"; Boolean)
        {
        }
        field(33020330; "Driving License No."; Text[30])
        {
        }
        field(33020331; Foreign; Boolean)
        {
        }
        field(33020332; "Passport No."; Text[80])
        {
        }
        field(33020333; "Passport Issue Date"; Date)
        {
        }
        field(33020334; "Passport Expiry Date"; Date)
        {
        }
        field(33020335; "Passport Issue Place"; Text[30])
        {
        }
        field(33020336; "Visa Type"; Option)
        {
            OptionCaption = ' ,Visit,Sponsered by Employer,Sponsered by Company,Husband Visa,Other';
            OptionMembers = " ",Visit,"Sponsered by Employer","Sponsered by Company","Husband Visa",Other;
        }
        field(33020337; "Work Permit No."; Text[30])
        {
        }
        field(33020338; "Work Permit Expiry Date"; Date)
        {
        }
        field(33020339; "Residency No."; Text[30])
        {
        }
        field(33020340; Insurance; Boolean)
        {
        }
        field(33020341; "Insurance Policy No."; Text[50])
        {
        }
        field(33020342; Designation; Text[50])
        {
        }
        field(33020343; "Special Case"; Boolean)
        {
        }
        field(33020344; "Grace Period"; Time)
        {
        }
        field(33020345; "Employment Type"; Option)
        {
            OptionMembers = " ","Full Time","Part Time",Contractual;
        }
        field(33020347; "Applicant No."; Code[20])
        {
            Description = '//Convert into employee from Vacancy';
            TableRelation = Application."No.";
        }
        field(33020348; "Father Name"; Text[50])
        {
        }
        field(33020349; "GrandFather Name"; Text[50])
        {
        }
        field(33020350; "Citizenship No."; Text[30])
        {
        }
        field(33020351; "Issue Office"; Text[30])
        {
        }
        field(33020352; "Issue District"; Text[30])
        {
        }
        field(33020353; P_WardNo; Code[5])
        {
        }
        field(33020354; P_VDC_NP; Text[30])
        {
        }
        field(33020355; P_District; Text[30])
        {
        }
        field(33020356; P_Zone; Text[30])
        {
        }
        field(33020357; T_WardNo; Code[5])
        {
        }
        field(33020358; T_VDC_NP; Text[30])
        {
        }
        field(33020359; T_District; Text[30])
        {
        }
        field(33020360; T_Zone; Text[30])
        {
        }
        field(33020361; "Blood Group"; Option)
        {
            Description = ' ,A+,A-,B+,B-,AB+,AB-,O+,O-';
            OptionCaption = ' ,A+,A-,B+,B-,AB+,AB-,O+,O-';
            OptionMembers = " ","A+","A-","B+","B-","AB+","AB-","O+","O-";
        }
        field(33020362; "Medical Certificate No."; Text[30])
        {
        }
        field(33020363; "First Appraisal ID"; Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(33020364; "Second Appraisal ID"; Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(33020365; "First Appraised"; Boolean)
        {
            // FieldClass = FlowField;
            // CalcFormula = Lookup(Appraisal.IsAppraised1 WHERE("Employee Code" = FIELD("No.")));//need to solve table error
        }
        field(33020366; "Second Appraised"; Boolean)
        {
            // FieldClass = FlowField;
            // CalcFormula = Lookup(Appraisal.IsAppraised2 WHERE("Employee Code" = FIELD("No.")));//need to solve table error
        }
        field(33020367; "Branch Name"; Text[50])
        {
            FieldClass = Normal;
        }
        field(33020368; Manager; Text[150])
        {
            FieldClass = Normal;
        }
        field(33020369; "First Appraiser"; Text[50])
        {
            // FieldClass = FlowField;
            // CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("First Appraisal ID")));//need to add full name
        }
        field(33020370; "Second Appraiser"; Text[50])
        {
            // FieldClass = FlowField;
            // CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("Second Appraisal ID")));//need to add full name

        }
        field(33020371; "CIT No."; Text[50])
        {
        }
        field(33020372; "PAN No."; Text[50])
        {
        }
        field(33020373; "PF No."; Text[50])
        {
        }
        field(33020374; "Mobile Phone No.2"; Text[30])
        {
        }
        field(33020375; "Manager Department Code"; Code[20])
        {
        }
        field(33020376; "Manager's Designation"; Option)
        {
            Description = ' ,HOD,Reporting 1,Reporting 2,Reporting 3,Reporting 4,Reporting 5,Reporting 6,Reporting 7,Reporting 8,Reporting 9,Reporting 10,VP,GM,CEO,EC,Reporting 11,Reporting 12,Reporting 13,Reporting 14,Reporting 15';
            OptionCaption = ' ,HOD,Reporting 1,Reporting 2,Reporting 3,Reporting 4,Reporting 5,Reporting 6,Reporting 7,Reporting 8,Reporting 9,Reporting 10,VP,GM,CEO,EC,Reporting 11,Reporting 12,Reporting 13,Reporting 14,Reporting 15';
            OptionMembers = " ",HOD,"Reporting 1","Reporting 2","Reporting 3","Reporting 4","Reporting 5","Reporting 6","Reporting 7","Reporting 8","Reporting 9","Reporting 10",VP,GM,CEO,EC,"Reporting 11","Reporting 12","Reporting 13","Reporting 14","Reporting 15";
        }
        field(33020377; "Exam Level"; Code[30])
        {
            TableRelation = "Exam Level Master".Code;
        }
        field(33020379; "Bank Account No."; Text[30])
        {
        }
        field(33020380; "Division Code"; Code[10])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Division));
        }
        field(33020381; Division; Text[50])
        {
        }
        field(33020382; "Workstation Code"; Code[10])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Workstation));
        }
        field(33020383; Workstation; Text[50])
        {
        }
        field(33020384; Company; Text[30])
        {
            TableRelation = Company.Name;
        }
        field(33020385; "Restrict Leave Earn"; Boolean)
        {
            Description = 'true if employee is absent without information, processed when attendance is posted';
        }
        field(33020386; "Leave Restrited Date"; Date)
        {
        }
        field(33020387; "Basic Pay"; Decimal)
        {
        }
        field(33020388; "Dearness Allowance"; Decimal)
        {
        }
        field(33020389; "Other Allowance"; Decimal)
        {
        }
        field(33020390; Total; Decimal)
        {
        }
        field(33020500; Level; Code[10])
        {
            TableRelation = "Salary Level";
        }
        field(33020501; Grade; Code[10])
        {
            TableRelation = "Salary Grade";
        }
        field(33020502; "Tax Code"; Code[20])
        {
            TableRelation = "Tax Setup Header";
        }
        field(33020503; "Premium of Life Insurance"; Decimal)
        {
        }
        field(33020504; "PF Balance"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Salary Ledger Entry"."Total Employer Contribution" WHERE("Employee Code" = FIELD("No.")));
        }
        field(33020505; "CIT Balance"; Decimal)
        {
            Editable = false;
        }
        field(33020506; "Tax Balance"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Salary Ledger Entry"."Tax Paid" WHERE("Employee Code" = FIELD("No.")));
        }
        field(33020507; "Donation Amount"; Decimal)
        {
        }
        field(33020508; "Tax on First Account"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Salary Ledger Entry"."Tax Paid" WHERE("Employee Code" = FIELD("No.")));
        }
        field(33020509; "Tax on Second Account"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Salary Ledger Entry"."Tax Paid" WHERE("Employee Code" = FIELD("No.")));
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Search Name")
        {
        }
        key(Key3; Status, "Union Code")
        {
        }
        key(Key4; Status, "Emplymt. Contract Code")
        {
        }
        key(Key5; "Last Name", "First Name", "Middle Name")
        {
        }
        key(Key6; "Full Name", "Job Title code")
        {
        }
        key(Key7; "User ID")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Full Name", Initials, "Job Title")
        {
        }
    }

    var
        HumanResSetup: Record "Human Resources Setup";
        Employee: Record Employee;
        Res: Record Resource;
        PostCode: Record "Post Code";
        AlternativeAddr: Record "Alternative Address";
        EmployeeQualification: Record "Employee Qualification";
        Relative: Record "Employee Relative";
        EmployeeAbsence: Record "Employee Absence";
        MiscArticleInformation: Record "Misc. Article Information";
        ConfidentialInformation: Record "Confidential Information";
        HumanResComment: Record "Human Resource Comment Line";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        EmployeeResUpdate: Codeunit "Employee/Resource Update";
        EmployeeSalespersonUpdate: Codeunit "Employee/Salesperson Update";
        DimMgt: Codeunit DimensionManagement;
        Text000: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        JobTitleRec: Record "Job Title";
        MasterRec: Record "Location Master";
        ExamDepartment: Record "Exam Department";
        DimensionValue: Record "Dimension Value";

    procedure AssistEdit(OldEmployee: Record Employee): Boolean
    begin
    end;

    procedure FullName(): Text[100]
    begin
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;

    procedure DisplayMap()
    var
        MapPoint: Record "Online Map Setup";
        MapMgt: Codeunit "Online Map Management";
    begin
    end;

    procedure InsertSalaryLog()
    var
        SalaryLog: Record "Salary Log";
        BasicWithGrade: Record "Basic Salary with Grade";
        ComponentUsage: Record "Payroll Component Usage";
        PGSetup: Record "Payroll General Setup";
    begin
    end;

    procedure CreateDimension()
    var
        DimValue: Record "Dimension Value";
    begin
    end;

    procedure SyncDimension(DimensionCode: Code[20]; "Code": Code[20]; Name: Code[50])
    var
        RecDimValue: Record "Dimension Value";
        CompanyRec: Record Company;
    begin
    end;
}

