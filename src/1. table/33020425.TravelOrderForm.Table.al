table 33020425 "Travel Order Form"
{
    // Designed and Developed by Jagesh Maharjan on 30-August-2013(earthquack);


    fields
    {
        field(10; "Travel Order No."; Code[30])
        {

            trigger OnValidate()
            begin
                IF "Travel Order No." <> xRec."Travel Order No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."Travel order No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(20; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(30; "Travel Type"; Option)
        {
            OptionMembers = " ",Planned,Emergency;
        }
        field(31; "No. Series"; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(40; "Traveler's ID"; Code[50])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                "Traveler's Name" := '';
                Department := '';
                "TADA (Nrs.)" := 0;
                ManagerID := '';
                Level := '';
                Designation := '';
                Grade := '';
                "Total (Nrs.)" := 0;

                Helper := FALSE;
                "Calculate 100%" := FALSE;
                Employee.RESET;
                Employee.SETRANGE("No.", "Traveler's ID");
                IF Employee.FINDFIRST THEN BEGIN
                    "Traveler's Name" := Employee."Full Name";
                    Designation := Employee."Job Title";
                    Department := Employee."Department Name";
                    ManagerID := Employee."Manager ID";
                    Level := Employee.Level;
                    Grade := Employee.Grade;
                    //MODIFY;
                    /*
                      TADAWithGrade.RESET;
                      TADAWithGrade.SETRANGE(TADAWithGrade.Level,Level);
                      TADAWithGrade.SETRANGE(TADAWithGrade.Grade,Grade);
                      IF TADAWithGrade.FINDFIRST THEN  BEGIN
                        TadaAmount := TADAWithGrade."TADA(per Day Nrs)" ;
                        "TADA (Nrs.)" := ("No. of Days" -1 ) * TadaAmount + TadaAmount * 0.4 ;
                        MODIFY;
                      END;
                     */ //Code moved to function CalculateTADA

                    CaculateTADA; //ZM Agile

                    //Level := TADAWithGrade.Level; Grade := TADAWithGrade.Grade;
                END;

                "Requested By" := USERID;
                "Requested Date" := TODAY;

            end;
        }
        field(41; "Traveler's Name"; Text[120])
        {
            Editable = false;
        }
        field(42; Designation; Text[120])
        {
            Editable = false;
        }
        field(43; Department; Text[120])
        {
            Editable = false;
        }
        field(44; "Travel Destination I"; Text[80])
        {
        }
        field(45; "Travel Destination II"; Text[80])
        {
        }
        field(46; "Travel Destination III"; Text[250])
        {
        }
        field(47; "Depature Date (AD)"; Date)
        {
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnValidate()
            begin
                CLEAR("No. of Days");
                CLEAR("Depature Date (BS)");
                CLEAR("TADA (Nrs.)");
                CLEAR("Arrival Date (AD)");
                CLEAR("Arrival Date (BS)");
                CLEAR("Mode Of Transportation");
                CLEAR("Total (Nrs.)");
                CLEAR("TADA (Nrs.)");


                IF "Depature Date (AD)" <> 0D THEN BEGIN
                    NDate.RESET;
                    NDate.SETRANGE("English Date", "Depature Date (AD)");
                    IF NDate.FINDFIRST THEN
                        "Depature Date (BS)" := NDate."Nepali Date";
                END;

                //"No. of Days" := "Arrival Date (AD)" - "Depature Date (AD)";
            end;
        }
        field(48; "Depature Date (BS)"; Code[15])
        {

            trigger OnValidate()
            begin
                CLEAR("No. of Days");
                CLEAR("Depature Date (AD)");
                //CLEAR("TADA (Nrs.)");
                CLEAR("Mode Of Transportation");

                IF "Depature Date (BS)" <> '' THEN BEGIN
                    NDate.RESET;
                    NDate.SETRANGE("Nepali Date", "Depature Date (BS)");
                    IF NDate.FINDFIRST THEN
                        "Depature Date (AD)" := NDate."English Date";
                END;
                VALIDATE("Depature Date (AD)");
            end;
        }
        field(49; "Arrival Date (AD)"; Date)
        {

            trigger OnValidate()
            begin
                CLEAR("No. of Days");
                CLEAR("Arrival Date (BS)");
                CLEAR("Mode Of Transportation");
                CLEAR("TADA (Nrs.)");
                //VALIDATE("Calculate 40%",FALSE);

                IF "Arrival Date (AD)" <> 0D THEN BEGIN
                    NDate.RESET;
                    NDate.SETRANGE("English Date", "Arrival Date (AD)");
                    IF NDate.FINDFIRST THEN
                        "Arrival Date (BS)" := NDate."Nepali Date";
                END;
                "No. of Days" := "Arrival Date (AD)" - "Depature Date (AD)" + 1;

                //VALIDATE("Traveler's ID");
            end;
        }
        field(50; "Arrival Date (BS)"; Code[15])
        {

            trigger OnValidate()
            begin
                CLEAR("No. of Days");
                CLEAR("Arrival Date (AD)");

                IF "Arrival Date (BS)" <> '' THEN BEGIN
                    NDate.RESET;
                    NDate.SETRANGE("Nepali Date", "Arrival Date (BS)");
                    IF NDate.FINDFIRST THEN
                        "Arrival Date (AD)" := NDate."English Date";
                END;

                VALIDATE("Arrival Date (AD)");
            end;
        }
        field(51; "No. of Days"; Integer)
        {
            Editable = false;

            trigger OnValidate()
            begin
                CLEAR("No. of Days");
                "No. of Days" := "Arrival Date (AD)" - "Depature Date (AD)" + 1;
            end;
        }
        field(52; "Mode Of Transportation"; Option)
        {
            OptionCaption = ' ,India Tour,Local Vehicle,Agni''s Vehicle,Personal Vehicle,Others,By Air within Nepal,Agni Logistic Vehicle';
            OptionMembers = " ","India Tour","Local Vehicle","Agni's Vehicle","Personal Vehicle",Others,"By Air within Nepal","Agni Logistic Vehicle";

            trigger OnValidate()
            begin
                CLEAR("TADA (Nrs.)");
                //CLEAR("Calculate 40%");
                /*
                IF "Mode Of Transportation" = "Mode Of Transportation":: "India Tour"THEN BEGIN
                    TADAWithGrade.RESET;
                    TADAWithGrade.SETRANGE(Level,Level);
                    TADAWithGrade.SETRANGE(Grade,Grade);
                    IF TADAWithGrade.FINDFIRST THEN
                    "TADA (Nrs.)" :=  ("No. of Days" - 1) * TADAWithGrade."TADA(Per Day Irs.)" + (TADAWithGrade."TADA(Per Day Irs.)" * (0.4));
                   // MESSAGE(FORMAT("TADA (Nrs.)"));
                END ELSE BEGIN
                    TADAWithGrade.RESET;
                    TADAWithGrade.SETRANGE(Level,Level);
                    TADAWithGrade.SETRANGE(Grade,Grade);
                    IF TADAWithGrade.FINDFIRST THEN
                    "TADA (Nrs.)" :=  ("No. of Days" - 1) * TADAWithGrade."TADA(per Day Nrs)" + (TADAWithGrade."TADA(per Day Nrs)" * (0.4));
                   // MESSAGE(FORMAT("TADA (Nrs.)"));
                END;
                */ //Code moved to function  CaculateTADA

                CaculateTADA;    //ZM Agile May 8, 2017

            end;
        }
        field(53; "Bus Transportation"; Decimal)
        {
            Description = 'If Mode Of Transportation is Others';
        }
        field(54; "Approved Type"; Option)
        {
            Description = 'If Travel Type is Emergency';
            OptionMembers = " ",Phone,Fax,Email;
        }
        field(60; "Transportation/Ticket (Nrs.)"; Decimal)
        {

            trigger OnLookup()
            begin
                "Total (Nrs.)" := "Transportation/Ticket (Nrs.)" + "Local Transportation (Nrs.)" + "TADA (Nrs.)" + "Fuel (Nrs.)";
            end;

            trigger OnValidate()
            begin
                "Total (Nrs.)" := "Transportation/Ticket (Nrs.)" + "Local Transportation (Nrs.)" + "TADA (Nrs.)" + "Fuel (Nrs.)";
            end;
        }
        field(61; "Local Transportation (Nrs.)"; Decimal)
        {

            trigger OnValidate()
            begin
                "Total (Nrs.)" := "Transportation/Ticket (Nrs.)" + "Local Transportation (Nrs.)" + "TADA (Nrs.)" + "Fuel (Nrs.)";
            end;
        }
        field(62; "TADA (Nrs.)"; Decimal)
        {
            Editable = true;

            trigger OnValidate()
            begin
                "Total (Nrs.)" := "Transportation/Ticket (Nrs.)" + "Local Transportation (Nrs.)" + "TADA (Nrs.)" + "Fuel (Nrs.)";
            end;
        }
        field(63; "Fuel (Nrs.)"; Decimal)
        {

            trigger OnValidate()
            begin
                "Total (Nrs.)" := "Transportation/Ticket (Nrs.)" + "Local Transportation (Nrs.)" + "TADA (Nrs.)" + "Fuel (Nrs.)";
            end;
        }
        field(64; "Total (Nrs.)"; Decimal)
        {

            trigger OnValidate()
            begin
                "Total (Nrs.)" := "Transportation/Ticket (Nrs.)" + "Local Transportation (Nrs.)" + "TADA (Nrs.)" + "Fuel (Nrs.)";
            end;
        }
        field(100; ManagerID; Code[50])
        {
            TableRelation = Employee.No.;
        }
        field(101; "Manager's Name"; Text[80])
        {
        }
        field(102; Approved; Boolean)
        {
        }
        field(103; "Approved By"; Text[80])
        {
        }
        field(104; "Approved Date"; Date)
        {
        }
        field(105; Posted; Boolean)
        {
        }
        field(106; "Posted By"; Code[50])
        {
            TableRelation = Table2000000002;
        }
        field(107; "Posted Date"; Date)
        {
        }
        field(108; Invalid; Boolean)
        {
        }
        field(109; "Invalid By"; Code[50])
        {
        }
        field(110; "Invalid Date"; Date)
        {
        }
        field(115; Level; Code[10])
        {
        }
        field(116; Grade; Code[10])
        {
        }
        field(117; "Requested By"; Code[50])
        {
        }
        field(118; "Requested Date"; Date)
        {
        }
        field(119; "Approved II"; Boolean)
        {
        }
        field(120; "Approved II By"; Code[50])
        {
        }
        field(121; "Approved II Date"; Date)
        {
        }
        field(50000; Helper; Boolean)
        {

            trigger OnValidate()
            begin
                /*
                TadaAmount := 0;
                IF "Calculate 40%" THEN BEGIN
                  "Calculate 100%" := FALSE;
                  TADAWithGrade.RESET;
                  TADAWithGrade.SETRANGE(TADAWithGrade.Level,Level);
                  TADAWithGrade.SETRANGE(TADAWithGrade.Grade,Grade);
                  IF TADAWithGrade.FINDFIRST THEN  BEGIN
                    TadaAmount := TADAWithGrade."TADA(per Day Nrs)" ;
                    "TADA (Nrs.)" := ("No. of Days" -1 ) * 0.4 * TadaAmount + TadaAmount * 0.4 ;
                    VALIDATE("TADA (Nrs.)");  //ZM Agile May 8, 2017   // to calculate total ( TADA (Nrs.))
                    MODIFY;
                  END;
                END ELSE BEGIN
                  TADAWithGrade.RESET;
                  TADAWithGrade.SETRANGE(TADAWithGrade.Level,Level);
                  TADAWithGrade.SETRANGE(TADAWithGrade.Grade,Grade);
                  IF TADAWithGrade.FINDFIRST THEN  BEGIN
                    TadaAmount := TADAWithGrade."TADA(per Day Nrs)" ;
                    "TADA (Nrs.)" := ("No. of Days" -1 ) * TadaAmount + TadaAmount * 0.4 ;
                  END;
                END;
                */   //Code moved to function CaculateTADA


                CaculateTADA; //ZM Agile

            end;
        }
        field(50001; "Calculate 100%"; Boolean)
        {

            trigger OnValidate()
            begin
                /*
                TadaAmount := 0;
                IF "Calculate 100%" THEN BEGIN
                  "Calculate 40%" := FALSE;
                  TADAWithGrade.RESET;
                  TADAWithGrade.SETRANGE(TADAWithGrade.Level,Level);
                  TADAWithGrade.SETRANGE(TADAWithGrade.Grade,Grade);
                  IF TADAWithGrade.FINDFIRST THEN  BEGIN
                    TadaAmount := TADAWithGrade."TADA(per Day Nrs)" ;
                    "TADA (Nrs.)" := ("No. of Days") * TadaAmount;
                    MODIFY;
                  END;
                END ELSE BEGIN
                  TADAWithGrade.RESET;
                  TADAWithGrade.SETRANGE(TADAWithGrade.Level,Level);
                  TADAWithGrade.SETRANGE(TADAWithGrade.Grade,Grade);
                  IF TADAWithGrade.FINDFIRST THEN  BEGIN
                    TadaAmount := TADAWithGrade."TADA(per Day Nrs)" ;
                    "TADA (Nrs.)" := ("No. of Days" -1 ) * TadaAmount + TadaAmount * 0.4 ;
                    VALIDATE("TADA (Nrs.)");
                    MODIFY;
                  END;
                END;
                */  //Code moved to function CaculateTADA
                CaculateTADA;  //ZM Agile

            end;
        }
        field(50002; "Travel Purpose"; Text[250])
        {
        }
        field(50003; Driver; Boolean)
        {

            trigger OnValidate()
            begin

                CaculateTADA; //ZM Agile
            end;
        }
        field(50004; "Calculate 20%"; Boolean)
        {

            trigger OnValidate()
            begin

                CaculateTADA;  //ZM Agile
            end;
        }
        field(50005; "Calculate 40%"; Boolean)
        {

            trigger OnValidate()
            begin

                CaculateTADA;  //ZM Agile
            end;
        }
    }

    keys
    {
        key(Key1; "Travel Order No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Travel Order No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD("Travel order No.");
            NoSeriesMngt.InitSeries(HRSetup."Travel order No.", xRec."No. Series", 0D, "Travel Order No.", "No. Series");
        END;
    end;

    var
        Employee: Record "5200";
        NoSeriesMngt: Codeunit "396";
        HRSetup: Record "5218";
        TravelOrder: Record "33020425";
        NDate: Record "33020302";
        AgniMgt: Codeunit "50000";
        TADAWithGrade: Record "33020502";
        TadaAmount: Decimal;
        Level: Code[10];
        Gerade: Code[10];

    [Scope('Internal')]
    procedure AssistEdit(OldTravelForm: Record "33020425"): Boolean
    begin
        TravelOrder := Rec;
        HRSetup.GET;
        HRSetup.TESTFIELD("Travel order No.");
        IF NoSeriesMngt.SelectSeries(HRSetup."Travel order No.", xRec."No. Series", TravelOrder."No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD("Travel order No.");
            NoSeriesMngt.SetSeries(TravelOrder."Travel Order No.");
            Rec := TravelOrder;
            EXIT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure InvalidOrder(TravelOrderNo: Code[20])
    var
        TravelOrder: Record "33020425";
        LeaveRegister: Record "33020343";
        ActivityLog: Record "33020551";
        HRPermission: Record "33020304";
    begin
        HRPermission.GET(USERID);
        IF HRPermission."HR Admin" THEN BEGIN
            IF CONFIRM('You you want to invalid the document?', TRUE) THEN BEGIN
                TravelOrder.RESET;
                TravelOrder.SETRANGE("Travel Order No.", TravelOrderNo);
                IF TravelOrder.FINDFIRST THEN BEGIN
                    TravelOrder.Invalid := TRUE;
                    TravelOrder."Invalid By" := USERID;
                    TravelOrder."Invalid Date" := TODAY;
                    TravelOrder.Approved := FALSE;
                    TravelOrder."Approved II" := FALSE;
                    TravelOrder.MODIFY;

                    LeaveRegister.RESET;
                    LeaveRegister.SETRANGE("External No", TravelOrderNo);
                    IF LeaveRegister.FINDFIRST THEN BEGIN
                        IF LeaveRegister."Activity Processed" THEN BEGIN
                            ActivityLog.RESET;
                            ActivityLog.SETRANGE("Employee No.", LeaveRegister."Employee No.");
                            ActivityLog.SETRANGE("Start Date", LeaveRegister."Leave Start Date");
                            ActivityLog.SETRANGE("End Date", LeaveRegister."Leave End Date");
                            ActivityLog.SETRANGE(Type, ActivityLog.Type::Travel);
                            IF ActivityLog.FINDFIRST THEN
                                ActivityLog.DELETE;
                        END;
                        LeaveRegister.DELETE;
                    END;
                    MESSAGE('The Travel has been successfully set as Invalid!');
                END;
            END;
        END ELSE
            ERROR('You do not have permission to Invalid the Document. Please contact HR Admin.');
    end;

    [Scope('Internal')]
    procedure CaculateTADA()
    var
        UnitAmount: Decimal;
    begin
        UnitAmount := 0;
        TADAWithGrade.RESET;
        TADAWithGrade.SETRANGE(TADAWithGrade.Level, Level);
        TADAWithGrade.SETRANGE(TADAWithGrade.Grade, Grade);
        TADAWithGrade.FINDFIRST;
        IF "Mode Of Transportation" = "Mode Of Transportation"::"India Tour" THEN
            UnitAmount := TADAWithGrade."TADA(Per Day Irs.)"
        ELSE
            UnitAmount := TADAWithGrade."TADA(per Day Nrs)";

        IF Helper THEN BEGIN
            "TADA (Nrs.)" := (0.4) * UnitAmount * ("No. of Days" - 1) + ((0.4) * UnitAmount) * (0.4);
        END ELSE IF "Calculate 20%" THEN BEGIN
            "TADA (Nrs.)" := (0.2) * UnitAmount * "No. of Days";
            //Agni Incorporate UPG
        END ELSE IF "Calculate 40%" THEN BEGIN
            "TADA (Nrs.)" := (0.4) * UnitAmount * "No. of Days";
            //Agni Incorporate UPG
        END ELSE IF Driver THEN BEGIN
            "TADA (Nrs.)" := (0.7) * UnitAmount * ("No. of Days" - 1) + ((0.7) * UnitAmount) * (0.4);
        END ELSE IF "Calculate 100%" THEN BEGIN
            "TADA (Nrs.)" := UnitAmount * "No. of Days";
        END ELSE BEGIN
            "TADA (Nrs.)" := UnitAmount * ("No. of Days" - 1) + (0.4) * UnitAmount;
        END;
        /*
        IF "Calculate 40%" THEN BEGIN
         "TADA (Nrs.)" := (0.4) * UnitAmount *"No. of Days";
        THEN ELSE IF "Calculate 20%" THEN BEGIN
         "TADA (Nrs.)" := (0.2) * UnitAmount *"No. of Days";
         THEN ELSE IF "Calculate 70%" THEN BEGIN
         "TADA (Nrs.)" := (0.7) * UnitAmount *"No. of Days";
        END ELSE IF "Calculate 100%" THEN BEGIN
         "TADA (Nrs.)" := UnitAmount * "No. of Days";
        END ELSE BEGIN
         "TADA (Nrs.)" := UnitAmount * ("No. of Days" - 1) + (0.4) * UnitAmount;
        END;
        */

        "Total (Nrs.)" := "Transportation/Ticket (Nrs.)" + "Local Transportation (Nrs.)" + "TADA (Nrs.)" + "Fuel (Nrs.)";

    end;
}

