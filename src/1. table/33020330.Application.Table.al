table 33020330 Application
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'Application No.';

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."Application Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Name; Text[100])
        {
        }
        field(3; Initials; Text[10])
        {
        }
        field(4; "Search Name"; Text[120])
        {
        }
        field(5; Address; Text[50])
        {
        }
        field(6; City; Text[30])
        {
            TableRelation = "Post Code".City;
        }
        field(7; Country; Text[30])
        {
            TableRelation = Country/Region.Code;
        }
        field(8;"Phone No.";Text[30])
        {
        }
        field(9;"Mobile No.";Text[30])
        {
        }
        field(10;Email;Text[120])
        {
        }
        field(11;Picture;BLOB)
        {
            SubType = Bitmap;
        }
        field(12;Gender;Option)
        {
            OptionMembers = " ",Male,Female;
        }
        field(13;Status;Option)
        {
            OptionCaption = 'Open,Shortlisted,Interviewed,Selected,Rejected,Employed,Hold,Future Requirement';
            OptionMembers = Open,Shortlisted,Interviewed,Selected,Rejected,Employed,Hold,"Future Requirement";
        }
        field(14;"No. Series";Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(15;"Entry Date";Date)
        {

            trigger OnValidate()
            begin
                "Additional Entry Date" := STPLSysMgmt.getNepaliDate("Entry Date");
            end;
        }
        field(16;"Additional Entry Date";Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020330,16);
            Editable = false;
        }
        field(17;"Application Date";Date)
        {

            trigger OnValidate()
            begin
                "Additional Application Date" := STPLSysMgmt.getNepaliDate("Application Date");
            end;
        }
        field(18;"Additional Application Date";Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020330,18);

            trigger OnValidate()
            begin
                "Application Date" := STPLSysMgmt.getEngDate("Additional Application Date");
            end;
        }
        field(19;"Applied Job Title";Code[20])
        {

            trigger OnValidate()
            begin
                //CALCFIELDS("Applied Job Title Descp.");
                
                 /*
                //Code to check for vacancy opening.
                HRSetup.GET;
                IF HRSetup."Apply System Restriction" THEN BEGIN
                  AddJob.RESET;
                  AddJob.SETRANGE("Job Title","Applied Job Title");
                  AddJob.SETFILTER("Opening Date",'%1..%2',0D,"Entry Date");
                  IF AddJob.FIND('+') THEN BEGIN
                    IF AddJob.Approved THEN BEGIN
                      IF AddJob.Closed THEN
                        ERROR(Text001,"Applied Job Title");
                    END ELSE IF AddJob.Disapproved THEN
                      ERROR(Text002,"Applied Job Title")
                    ELSE
                      ERROR(Text000,"Applied Job Title");
                  END;
                END;
                  */

            end;
        }
        field(20;"Applied Job Title Descp.";Text[100])
        {
            CalcFormula = Lookup("Job Title".Description WHERE (Code=FIELD(Applied Job Title)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(21;"Birth Date";Date)
        {

            trigger OnValidate()
            begin
                "Additional Birth Date" := STPLSysMgmt.getNepaliDate("Birth Date");
            end;
        }
        field(22;"Additional Birth Date";Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020330,22);

            trigger OnValidate()
            begin
                "Birth Date" := STPLSysMgmt.getEngDate("Additional Birth Date");
            end;
        }
        field(23;"Social Security No.";Code[30])
        {
        }
        field(24;"Family Status";Option)
        {
            OptionMembers = " ",Single,Married,"M+1","M+2","M+3","M+4";
        }
        field(25;Religion;Text[50])
        {
        }
        field(26;Nationality;Text[50])
        {
        }
        field(27;"Applied Type";Option)
        {
            OptionMembers = " ","Full Time","Part Time",Contractual;
        }
        field(28;"Driving License";Boolean)
        {
        }
        field(29;"Driving License No.";Code[30])
        {
        }
        field(30;Foreign;Boolean)
        {
            Enabled = false;
        }
        field(31;"Passport No.";Code[30])
        {
        }
        field(32;"Passport Issue Date";Date)
        {

            trigger OnValidate()
            begin
                "Additional Passport Issue Date" := STPLSysMgmt.getNepaliDate("Passport Issue Date");
            end;
        }
        field(33;"Additional Passport Issue Date";Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020330,33);

            trigger OnValidate()
            begin
                "Passport Issue Date" := STPLSysMgmt.getEngDate("Additional Passport Issue Date");
            end;
        }
        field(34;"Passport Expiry Date";Date)
        {

            trigger OnValidate()
            begin
                "Add. Passport Expiry Date" := STPLSysMgmt.getNepaliDate("Passport Expiry Date");
            end;
        }
        field(35;"Add. Passport Expiry Date";Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020330,35);

            trigger OnValidate()
            begin
                "Passport Expiry Date" := STPLSysMgmt.getEngDate("Add. Passport Expiry Date");
            end;
        }
        field(36;"Passport Issued Place";Text[50])
        {
        }
        field(37;"Visa Type";Option)
        {
            OptionMembers = " ",Visit,"Sponsered by Employer","Sponsered by Company","Husband Visa",Other;
        }
        field(38;"Work Permit No.";Code[30])
        {
        }
        field(39;"Work Permit Expiry Date";Date)
        {

            trigger OnValidate()
            begin
                "Add. Work Permist Expiry Date" := STPLSysMgmt.getNepaliDate("Work Permit Expiry Date");
            end;
        }
        field(40;"Add. Work Permist Expiry Date";Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020330,40);

            trigger OnValidate()
            begin
                "Work Permit Expiry Date" := STPLSysMgmt.getEngDate("Add. Work Permist Expiry Date");
            end;
        }
        field(41;"Residency No.";Code[30])
        {
        }
        field(42;Employed;Boolean)
        {
            Editable = false;
        }
        field(43;"Employed Date";Date)
        {
            Editable = false;

            trigger OnValidate()
            begin
                "Add. Employed Date" := STPLSysMgmt.getNepaliDate("Employed Date");
            end;
        }
        field(44;"Add. Employed Date";Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020330,44);
            Editable = false;
        }
        field(45;"Offer Sent";Boolean)
        {
            Editable = false;
        }
        field(46;"Offer Sent Date";Date)
        {
            Editable = false;

            trigger OnValidate()
            begin
                "Add. Offer Sent Date" := STPLSysMgmt.getNepaliDate("Offer Sent Date");
            end;
        }
        field(47;"Add. Offer Sent Date";Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020330,47);
            Editable = false;
        }
        field(48;Shortlisted;Boolean)
        {
            Caption = 'Shortlist';
        }
        field(49;Department;Code[20])
        {
            Caption = 'Department';
            TableRelation = "Location Master".Code;
        }
        field(50;Select;Boolean)
        {
        }
        field(51;"Interviewed Date";Date)
        {

            trigger OnValidate()
            begin
                "Add. Interviewed Date" := STPLSysMgmt.getNepaliDate("Interviewed Date");
            end;
        }
        field(52;"Add. Interviewed Date";Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020330,52);
            Caption = 'Add. Interviewed Date';
        }
        field(53;Reject;Boolean)
        {
        }
        field(54;Interviewed;Boolean)
        {
        }
        field(55;"Shortlisted Date";Date)
        {

            trigger OnValidate()
            begin
                "Add. Shortlisted Date" := STPLSysMgmt.getNepaliDate("Shortlisted Date");
            end;
        }
        field(56;"Add. Shortlisted Date";Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020330,56);
        }
        field(57;"CI Date";Date)
        {
            Enabled = false;

            trigger OnValidate()
            begin
                "Add. CI Date" := STPLSysMgmt.getNepaliDate("CI Date");
            end;
        }
        field(58;"Add. CI Date";Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020330,58);
            Enabled = false;
        }
        field(59;"SR Date";Date)
        {
            Caption = 'Selected/Rejected Date';

            trigger OnValidate()
            begin
                "Add. SR Date" := STPLSysMgmt.getNepaliDate("SR Date");
            end;
        }
        field(60;"Add. SR Date";Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020330,60);
        }
        field(61;"Generated Date";Date)
        {
            Enabled = false;

            trigger OnValidate()
            begin
                "Add. Generated Date" := STPLSysMgmt.getNepaliDate("Generated Date");
            end;
        }
        field(62;"Add. Generated Date";Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020330,62);
            Enabled = false;
        }
        field(63;"Date Filter";Date)
        {
            FieldClass = FlowFilter;
        }
        field(64;"Vacancy No.";Code[20])
        {
            TableRelation = "Vacancy Header New";

            trigger OnValidate()
            begin
                   CALCFIELDS("Applied Job Title Descp.");
                  AddJob.SETRANGE("Vacany No.","Vacancy No.");
                 IF AddJob.FIND('-') THEN BEGIN
                    "Applied Job Title" := AddJob."Job Title";
                   // "Applied Job Title Descp." := AddJob."Job Description";
                 END;
            end;
        }
        field(65;ConvertToEmployee;Boolean)
        {
        }
        field(66;"Application No.";Code[20])
        {
            TableRelation = "Application New";
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
          HRSetup.GET;
          HRSetup.TESTFIELD("Application Nos.");
          NoSeriesMngt.InitSeries(HRSetup."Application Nos.",xRec."No. Series",0D,"No.","No. Series");
        END;
    end;

    var
        Application: Record "33020330";
        Text000: Label 'Vacancy - %1, is not Approved.';
        Text001: Label 'Vacancy - %1, is closed.';
        Text002: Label 'Vacancy - %1, is disapproved.';
        NoSeriesMngt: Codeunit "396";
        STPLSysMgmt: Codeunit "50000";
        HRSetup: Record "5218";
        AddJob: Record "33020327";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        WITH Application DO BEGIN
          Application := Rec;
          HRSetup.GET;
          HRSetup.TESTFIELD("Application Nos.");
          IF NoSeriesMngt.SelectSeries(HRSetup."Application Nos.",xRec."No. Series","No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD("Application Nos.");
            NoSeriesMngt.SetSeries("No.");
            Rec := Application;
            EXIT(TRUE);
          END;
        END;
    end;
}

