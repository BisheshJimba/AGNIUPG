table 33020426 "Travel Order Voucher"
{
    // Designed and Developed by Jagesh Maharjan on 30-August-2013;
    //   *Travelers restricted to fill only 3 category of destination
    //   *Travelers fills the No.s of days consumed as per destination category
    //   *Service Provider field for travelers whose accomodation are bared by the 3rd-party
    //     -if service provider exist TADA bills only 40% if not 100%
    //   *All amount are called from the Basic Salary with line according to grade and level
    //   *if mode of transportation is different amount will be different as such for "Air" mode IRS. amount is called else Nrs.


    fields
    {
        field(10; "Travel Order Voucher No."; Code[20])
        {
        }
        field(20; "Travel Order Form No."; Code[20])
        {
            TableRelation = "Travel Order Form" WHERE(Approved = CONST(Yes));

            trigger OnValidate()
            begin
                TravelOrderForm.RESET;
                TravelOrderForm.SETRANGE("Travel Order No.", "Travel Order Form No.");
                IF TravelOrderForm.FINDFIRST THEN BEGIN
                    "Travelr's ID No." := TravelOrderForm."Traveler's ID";
                    "Traveler's Name" := TravelOrderForm."Traveler's Name";
                    Designation := TravelOrderForm.Designation;
                    Department := TravelOrderForm.Department;
                    "Depature Date (AD)" := TravelOrderForm."Depature Date (AD)";
                    "Arrival Date (AD)" := TravelOrderForm."Arrival Date (AD)";
                    "Travel Destination I" := TravelOrderForm."Travel Destination I";
                    "Travel Destination II" := TravelOrderForm."Travel Destination II";
                    "Travel Destination III" := TravelOrderForm."Travel Destination III";
                    "Mode Of Transportation" := TravelOrderForm."Mode Of Transportation";
                    "Fuel Expenses (Nrs.)" := TravelOrderForm."Fuel (Nrs.)";       //ZM Agile
                    "Bus Transportation" := TravelOrderForm."Local Transportation (Nrs.)";  //ZM Agile
                    "Travel Purpose" := TravelOrderForm."Travel Purpose";
                    "Advance Taken" := TravelOrderForm."Total (Nrs.)";
                    //"TADA/Hotel Bill (I) (Nrs.)" := TravelOrderForm."Total (Nrs.)";
                    VALIDATE("Days (Destination I)", (TravelOrderForm."Arrival Date (AD)" - TravelOrderForm."Depature Date (AD)" + 1));
                END;
                /*VALIDATE("Days (Destination I)","Days (Destination I)");
                VALIDATE("Days (Destination II)","Days (Destination II)");
                VALIDATE("Days (Destination III)","Days (Destination III)");   */

                TotalAmount;
                TotalExpense;

            end;
        }
        field(21; "Travelr's ID No."; Code[50])
        {
            Editable = false;
            TableRelation = Employee;
        }
        field(30; "Traveler's Name"; Text[80])
        {
            Editable = false;
        }
        field(31; Designation; Text[100])
        {
            Editable = false;
        }
        field(32; Department; Text[100])
        {
            Editable = false;
        }
        field(33; "Depature Date (AD)"; Date)
        {

            trigger OnValidate()
            begin
                //NoOfDays := "Arrival Date (AD)" - "Depature Date (AD)" + 1;
            end;
        }
        field(35; "Arrival Date (AD)"; Date)
        {

            trigger OnValidate()
            begin
                //NoOfDays := "Arrival Date (AD)" - "Depature Date (AD)" + 1;
                VALIDATE("Days (Destination I)", ("Arrival Date (AD)" - "Depature Date (AD)" + 1));
            end;
        }
        field(37; "Travel Destination I"; Text[250])
        {
            Editable = true;
        }
        field(38; "Travel Destination II"; Text[250])
        {
            Editable = false;
        }
        field(39; "Travel Destination III"; Text[250])
        {
            Editable = false;
        }
        field(45; "Days (Destination I)"; Decimal)
        {

            trigger OnValidate()
            begin
                CLEAR("TADA/Hotel Bill (I) (Nrs.)");
                CLEAR("TADA Return");

                /*
                IF "Service Provided" THEN BEGIN
                Employee.RESET;
                Employee.SETRANGE("No.","Travelr's ID No.");
                IF Employee.FINDFIRST THEN BEGIN
                   TADAWithGade.SETRANGE(TADAWithGade.Level,Employee.Level);
                   TADAWithGade.SETRANGE(TADAWithGade.Grade,Employee.Grade);
                   IF TADAWithGade.FINDFIRST THEN
                    IF ("Mode Of Transportation" = "Mode Of Transportation"::"India Tour") THEN  BEGIN
                      CaculateTADA(TADAWithGade."TADA(Per Day Irs.)");  //ZM Agile
                      //"TADA I (40%) (Nrs.)" :=  (0.4) * TADAWithGade."TADA(Per Day Irs.)" * "Days (Destination I)" ;
                     END ELSE
                      CaculateTADA(TADAWithGade."TADA(per Day Nrs)");  //ZM Agile
                      //"TADA I (40%) (Nrs.)" :=  (0.4) * TADAWithGade."TADA(per Day Nrs)" * "Days (Destination I)";
                END
                END;
                */    //ZM Agile Code moved to function CalculateTADA

                //IF NOT "Service Provided" THEN BEGIN
                Employee.RESET;
                Employee.SETRANGE("No.", "Travelr's ID No.");
                IF Employee.FINDFIRST THEN BEGIN
                    TADAWithGade.SETRANGE(TADAWithGade.Level, Employee.Level);
                    TADAWithGade.SETRANGE(TADAWithGade.Grade, Employee.Grade);
                    IF TADAWithGade.FINDFIRST THEN BEGIN
                        IF ("Mode Of Transportation" = "Mode Of Transportation"::"India Tour") AND
                          ("Days (Destination I)" <> 0) THEN BEGIN
                            CaculateTADA(TADAWithGade."TADA(Per Day Irs.)");  //ZM Agile
                                                                              // "TADA I (40%) (Nrs.)" :=  (0.4) * TADAWithGade."TADA(Per Day Irs.)";
                                                                              // "TADA/Hotel Bill (I) (Nrs.)" := TADAWithGade."TADA(Per Day Irs.)" * ("Days (Destination I)" -1);
                        END
                        ELSE
                            IF (("Days (Destination I)" <> 0)) THEN BEGIN
                                CaculateTADA(TADAWithGade."TADA(per Day Nrs)");  //ZM Agile
                                                                                 //   "TADA/Hotel Bill (I) (Nrs.)" := TADAWithGade."TADA(per Day Nrs)" * ("Days (Destination I)" - 1);
                                                                                 //   "TADA I (40%) (Nrs.)" := (0.4) * TADAWithGade."TADA(per Day Nrs)";

                            END;
                    END;
                END;
                //END;


                TotalAmount;
                TotalExpense;

                /*
                TravelOrder.RESET;
                TravelOrder.SETRANGE("Travel Order No.","Travel Order Form No.");
                IF TravelOrder.FINDFIRST THEN BEGIN
                   TravelOrder.VALIDATE("Arrival Date (AD)","Arrival Date (AD)");
                   TravelOrder.MODIFY;
                END;
                */        //Commented may 8, 2017  ZM-Agile    //No need to change in approved travel order form

            end;
        }
        field(46; "Days (Destination II)"; Decimal)
        {

            trigger OnValidate()
            begin
                /*
                CLEAR("TADA/Hotel Bill (II) (Nrs.)");
                CLEAR("TADA II (40%) (Nrs.)");
                
                IF "Service Provided" THEN BEGIN
                Employee.RESET;
                Employee.SETRANGE("No.","Travelr's ID No.");
                IF Employee.FINDFIRST THEN BEGIN
                   TADAWithGade.SETRANGE(TADAWithGade.Level,Employee.Level);
                   TADAWithGade.SETRANGE(TADAWithGade.Grade,Employee.Grade);
                   IF TADAWithGade.FINDFIRST THEN
                    IF ("Mode Of Transportation" = "Mode Of Transportation"::"India Tour") THEN
                    "TADA II (40%) (Nrs.)" := (0.4) * TADAWithGade."TADA(Per Day Irs.)" * "Days (Destination II)"
                    ELSE
                    "TADA II (40%) (Nrs.)" := (0.4) * TADAWithGade."TADA(per Day Nrs)" * "Days (Destination II)";
                END
                END;
                IF NOT "Service Provided" THEN BEGIN
                Employee.RESET;
                Employee.SETRANGE("No.","Travelr's ID No.");
                IF Employee.FINDFIRST THEN BEGIN
                   TADAWithGade.SETRANGE(TADAWithGade.Level,Employee.Level);
                   TADAWithGade.SETRANGE(TADAWithGade.Grade,Employee.Grade);
                   IF TADAWithGade.FINDFIRST THEN BEGIN
                    IF ("Mode Of Transportation" = "Mode Of Transportation"::"India Tour") AND
                        ("Days (Destination II)" <> 0)THEN BEGIN
                        "TADA II (40%) (Nrs.)" := (0.4) * TADAWithGade."TADA(Per Day Irs.)";
                      "TADA/Hotel Bill (II) (Nrs.)" := TADAWithGade."TADA(Per Day Irs.)" * ("Days (Destination II)" -1);
                      END
                    ELSE IF (("Days (Destination II)" <> 0)) THEN BEGIN
                    "TADA/Hotel Bill (II) (Nrs.)" := TADAWithGade."TADA(per Day Nrs)" * ("Days (Destination II)" - 1);
                    "TADA II (40%) (Nrs.)" := (0.4) * TADAWithGade."TADA(per Day Nrs)" ;
                    END;
                    END
                END
                END;
                
                TotalAmount;
                TotalExpense;
                */

            end;
        }
        field(47; "Days (Destination III)"; Decimal)
        {

            trigger OnValidate()
            begin
                /*
                CLEAR("TADA/Hotel Bill (III) (Nrs.)");
                CLEAR("TADA III (40%) (Nrs.)");
                
                IF "Service Provided" THEN BEGIN
                Employee.RESET;
                Employee.SETRANGE("No.","Travelr's ID No.");
                IF Employee.FINDFIRST THEN BEGIN
                   TADAWithGade.SETRANGE(TADAWithGade.Level,Employee.Level);
                   TADAWithGade.SETRANGE(TADAWithGade.Grade,Employee.Grade);
                   IF TADAWithGade.FINDFIRST THEN
                    IF "Mode Of Transportation" = "Mode Of Transportation"::"India Tour" THEN
                    "TADA III (40%) (Nrs.)" := (0.4) * TADAWithGade."TADA(Per Day Irs.)" * "Days (Destination III)"
                    ELSE
                    "TADA III (40%) (Nrs.)" := (0.4) * TADAWithGade."TADA(per Day Nrs)" * "Days (Destination III)";
                END
                END;
                IF NOT "Service Provided" THEN BEGIN
                Employee.RESET;
                Employee.SETRANGE("No.","Travelr's ID No.");
                IF Employee.FINDFIRST THEN BEGIN
                   TADAWithGade.SETRANGE(TADAWithGade.Level,Employee.Level);
                   TADAWithGade.SETRANGE(TADAWithGade.Grade,Employee.Grade);
                   IF TADAWithGade.FINDFIRST THEN BEGIN
                    IF ("Mode Of Transportation" = "Mode Of Transportation"::"India Tour") AND
                        ("Days (Destination III)" <> 0)THEN BEGIN
                      "TADA III (40%) (Nrs.)" :=  (0.4) * TADAWithGade."TADA(Per Day Irs.)";
                      "TADA/Hotel Bill (III) (Nrs.)" :=  TADAWithGade."TADA(Per Day Irs.)" * ("Days (Destination III)" -1);
                      END
                    ELSE IF (("Days (Destination III)" <> 0)) THEN BEGIN
                    "TADA/Hotel Bill (III) (Nrs.)" := TADAWithGade."TADA(per Day Nrs)" * ("Days (Destination III)" - 1);
                    "TADA III (40%) (Nrs.)" := (0.4) * TADAWithGade."TADA(per Day Nrs)" ;
                    END;
                    END
                END
                END;
                TotalAmount;
                TotalExpense;
                */

            end;
        }
        field(50; "TADA/Hotel Bill (I) (Nrs.)"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                /*"Airport Tax (Nrs.)" := "TADA/Hotel Bill (I) (Nrs.)" + "TADA I (40%) (Nrs.)" + "Air Ticket (Nrs.)" + "Airport Tax (Nrs.)" +
                                "Bus Ticket (Nrs.)" + "TADA I (40%) (Nrs.)" + "Fare 1 (Nrs.)" + "Fare 2 (Nrs.)" + "Road Tax (Nrs.)" +
                                "Train Ticket (Nrs.)" + "Air Ticket (Nrs.)" + "Guest Expenses (Nrs.)" + "Training Expenses (Nrs.)" +
                                "Advance Taken" ;
                       */

            end;
        }
        field(51; "TADA/Hotel Bill (II) (Nrs.)"; Decimal)
        {
            Editable = false;
        }
        field(52; "TADA/Hotel Bill (III) (Nrs.)"; Decimal)
        {
            Editable = false;
        }
        field(55; "TADA Return"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                /*"Airport Tax (Nrs.)" := "TADA/Hotel Bill (I) (Nrs.)" + "TADA I (40%) (Nrs.)" + "Air Ticket (Nrs.)" + "Airport Tax (Nrs.)" +
                                "Bus Ticket (Nrs.)" + "TADA I (40%) (Nrs.)" + "Fare 1 (Nrs.)" + "Fare 2 (Nrs.)" + "Road Tax (Nrs.)" +
                                "Train Ticket (Nrs.)" + "Air Ticket (Nrs.)" + "Guest Expenses (Nrs.)" + "Training Expenses (Nrs.)" +
                                "Advance Taken" ;*/
                TotalAmount;
                TotalExpense;

            end;
        }
        field(56; "TADA II (40%) (Nrs.)"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                TotalAmount;
                TotalExpense;
            end;
        }
        field(57; "TADA III (40%) (Nrs.)"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                TotalAmount;
                TotalExpense;
            end;
        }
        field(60; "Air Ticket (Nrs.)"; Decimal)
        {

            trigger OnValidate()
            begin
                TotalAmount;
                TotalExpense;
            end;
        }
        field(70; "Airport Tax (Nrs.)"; Decimal)
        {

            trigger OnValidate()
            begin
                TotalAmount;
                TotalExpense;
            end;
        }
        field(71; "Bus Transportation"; Decimal)
        {
            Editable = true;

            trigger OnValidate()
            begin
                TotalAmount;
                TotalExpense;
            end;
        }
        field(72; "Fuel Expenses (Nrs.)"; Decimal)
        {

            trigger OnValidate()
            begin
                TotalAmount;
                TotalExpense;
            end;
        }
        field(75; "Bus Ticket (Nrs.)"; Decimal)
        {

            trigger OnValidate()
            begin
                TotalAmount;
                TotalExpense;
            end;
        }
        field(80; "Local Conveyance (Nrs.)"; Decimal)
        {
        }
        field(85; "Fare 1 (Nrs.)"; Decimal)
        {
            Description = 'Bus/Taxi/Micro from Home to Airport';
        }
        field(90; "Fare 2 (Nrs.)"; Decimal)
        {
            Description = 'Bus/Taxi/Micro from Airport to Home';
        }
        field(95; "Road Tax (Nrs.)"; Decimal)
        {

            trigger OnValidate()
            begin
                TotalAmount;
                TotalExpense;
            end;
        }
        field(100; "Train Ticket (Nrs.)"; Decimal)
        {

            trigger OnValidate()
            begin
                TotalAmount;
                TotalExpense;
            end;
        }
        field(105; "Others (Nrs.)"; Decimal)
        {

            trigger OnValidate()
            begin
                TotalAmount;
                TotalExpense;
            end;
        }
        field(110; "Guest Expenses (Nrs.)"; Decimal)
        {

            trigger OnValidate()
            begin
                TotalAmount;
                TotalExpense;
            end;
        }
        field(115; "Training Expenses (Nrs.)"; Decimal)
        {

            trigger OnValidate()
            begin
                TotalAmount;
                TotalExpense;
            end;
        }
        field(120; "Total Expenses (Nrs.)"; Decimal)
        {
        }
        field(125; "Advance Taken"; Decimal)
        {
            Editable = true;

            trigger OnValidate()
            begin
                TotalAmount;
                TotalExpense;
            end;
        }
        field(130; "Service Provided"; Boolean)
        {

            trigger OnValidate()
            begin
                VALIDATE("Days (Destination I)");
                VALIDATE("Days (Destination II)");
                VALIDATE("Days (Destination III)");
            end;
        }
        field(131; "Mode Of Transportation"; Option)
        {
            OptionCaption = ' ,India Tour,Local Vehicle,Agni''s Vehicle,Personal Vehicle,Others,By Air within Nepal';
            OptionMembers = " ","India Tour","Local Vehicle","Agni's Vehicle","Personal Vehicle",Others,"By Air within Nepal";

            trigger OnValidate()
            begin
                VALIDATE("Days (Destination I)");
                VALIDATE("Days (Destination II)");
                VALIDATE("Days (Destination III)");
            end;
        }
        field(132; "Total Amount"; Decimal)
        {
        }
        field(133; "Journal Template Name"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(134; "Journal Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE(Journal Template Name=FIELD(Journal Template Name));
        }
        field(135; "G/L Account No."; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(136; "Travel Purpose"; Text[250])
        {
        }
        field(137; "Creation Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Travel Order Form No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Creation Date" := TODAY; //Min
    end;

    var
        TravelOrderForm: Record "33020425";
        Employee: Record "5200";
        TADAWithGade: Record "33020502";
        NoOfDays: Decimal;
        TravelOrder: Record "33020425";

    [Scope('Internal')]
    procedure TotalAmount()
    begin
        "Total Amount" := "TADA/Hotel Bill (I) (Nrs.)" + "TADA/Hotel Bill (II) (Nrs.)" + "TADA/Hotel Bill (III) (Nrs.)" +
                "Airport Tax (Nrs.)" + "Bus Ticket (Nrs.)" + "Bus Transportation" + "Fuel Expenses (Nrs.)" + "TADA Return" +
                "TADA II (40%) (Nrs.)" + "TADA III (40%) (Nrs.)" + "Road Tax (Nrs.)" + "Train Ticket (Nrs.)" + "Air Ticket (Nrs.)" +
                "Guest Expenses (Nrs.)" + "Training Expenses (Nrs.)" - "Advance Taken" + "Others (Nrs.)";
    end;

    [Scope('Internal')]
    procedure TotalExpense()
    begin
        "Total Expenses (Nrs.)" := "TADA/Hotel Bill (I) (Nrs.)" + "TADA/Hotel Bill (II) (Nrs.)" + "TADA/Hotel Bill (III) (Nrs.)" +
                "Airport Tax (Nrs.)" + "Bus Ticket (Nrs.)" + "Bus Transportation" + "Fuel Expenses (Nrs.)" + "TADA Return" +
                "TADA II (40%) (Nrs.)" + "TADA III (40%) (Nrs.)" + "Road Tax (Nrs.)" + "Train Ticket (Nrs.)" + "Air Ticket (Nrs.)" +
                "Guest Expenses (Nrs.)" + "Training Expenses (Nrs.)" + "Others (Nrs.)";
    end;

    [Scope('Internal')]
    procedure CaculateTADA(UnitAmount: Decimal)
    var
        TravelOrder: Record "33020425";
    begin
        TravelOrder.RESET;
        TravelOrder.SETRANGE("Travel Order No.", "Travel Order Form No.");
        IF TravelOrder.FINDFIRST THEN BEGIN
            IF (TravelOrder.Helper) OR "Service Provided" THEN BEGIN
                "TADA/Hotel Bill (I) (Nrs.)" := ((0.4) * UnitAmount) * ("Days (Destination I)" - 1);
                "TADA Return" := ((0.4) * UnitAmount) * (0.4);
            END ELSE
                IF TravelOrder."Calculate 100%" THEN BEGIN
                    "TADA/Hotel Bill (I) (Nrs.)" := UnitAmount * "Days (Destination I)";
                    "TADA Return" := 0;
                END ELSE
                    IF TravelOrder.Driver THEN BEGIN
                        "TADA/Hotel Bill (I) (Nrs.)" := ((0.7) * UnitAmount) * ("Days (Destination I)" - 1);
                        "TADA Return" := ((0.7) * UnitAmount) * (0.4);
                        //Agni Incorporate UPG
                    END ELSE
                        IF TravelOrder."Calculate 40%" THEN BEGIN
                            "TADA/Hotel Bill (I) (Nrs.)" := ((0.4) * UnitAmount) * "Days (Destination I)";
                            "TADA Return" := 0;
                            //Agni Incorporate UPG
                        END ELSE
                            IF TravelOrder."Calculate 20%" THEN BEGIN
                                "TADA/Hotel Bill (I) (Nrs.)" := ((0.2) * UnitAmount) * "Days (Destination I)";
                                "TADA Return" := 0;
                            END ELSE BEGIN
                                "TADA/Hotel Bill (I) (Nrs.)" := UnitAmount * ("Days (Destination I)" - 1);
                                "TADA Return" := (0.4) * UnitAmount;
                            END;
        END;
    end;
}

