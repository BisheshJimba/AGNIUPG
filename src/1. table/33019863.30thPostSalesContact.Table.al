table 33019863 "30th Post Sales Contact"
{
    DataPerCompany = true;

    fields
    {
        field(1; "No."; Integer)
        {
            AutoIncrement = false;
            BlankZero = true;
            MinValue = 0;
        }
        field(2; "Registration No."; Code[20])
        {

            trigger OnValidate()
            begin
                VehRec.RESET;
                VehRec.SETRANGE("Registration No.", "Registration No.");
                IF VehRec.FINDFIRST THEN BEGIN
                    VIN := VehRec.VIN;
                    "Engine No." := VehRec."Engine No.";
                END;
            end;
        }
        field(3; Model; Code[20])
        {
            TableRelation = Model;
        }
        field(4; Odometer; Integer)
        {
            BlankNumbers = BlankZero;
        }
        field(5; Dealer; Text[50])
        {
        }
        field(6; VIN; Code[20])
        {
        }
        field(7; "Engine No."; Code[20])
        {
        }
        field(8; "Sales Date"; Date)
        {
        }
        field(9; "Customer No."; Code[20])
        {
            TableRelation = Customer.No.;

            trigger OnValidate()
            begin
                Customer.RESET;
                Customer.SETRANGE("No.", "Customer No.");
                IF Customer.FINDFIRST THEN BEGIN
                    Name := Customer.Name;
                    Address := Customer.Address;
                    "E-mail" := Customer."E-Mail";
                    "Fax No." := Customer."Fax No.";
                    "Phone No." := Customer."Phone No.";
                    "Mobile No." := Customer."Mobile No.";
                END;
            end;
        }
        field(10; Name; Text[50])
        {
            Editable = false;
        }
        field(11; Address; Text[50])
        {
        }
        field(12; "E-mail"; Text[80])
        {
        }
        field(13; "Fax No."; Text[30])
        {
        }
        field(14; "Phone No."; Text[30])
        {
        }
        field(15; "Mobile No."; Code[50])
        {
        }
        field(16; "Is your Vehicle"; Option)
        {
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(17; "Any Concerns at Present"; Option)
        {
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(18; "Ride, Handling & Braking"; Text[100])
        {
        }
        field(19; Seats; Text[100])
        {
        }
        field(20; "Sound System"; Text[100])
        {
        }
        field(21; "Vehicle Interior"; Text[100])
        {
        }
        field(22; Engine; Text[100])
        {
        }
        field(23; "Features & Controls"; Text[100])
        {
        }
        field(24; HVAC; Text[100])
        {
        }
        field(25; "Vehicle Exterior"; Text[100])
        {
        }
        field(26; Transmission; Text[100])
        {
        }
        field(27; Others; Text[100])
        {
        }
        field(28; "Performance of Vehicle"; Option)
        {
            OptionCaption = ' ,Very Satisfied,Satisfied,Very Dissatisfied,Dissatisfied';
            OptionMembers = " ","Very Satisfied",Satisfied,"Very Dissatisfied",Dissatisfied;
        }
        field(29; "Services of the dealer"; Option)
        {
            OptionCaption = ' ,Very Satisfied,Satisfied,Very Dissatisfied,Dissatisfied';
            OptionMembers = " ","Very Satisfied",Satisfied,"Very Dissatisfied",Dissatisfied;
        }
        field(30; "Overall Satisfaction"; Option)
        {
            OptionCaption = ' ,Very Satisfied,Satisfied,Very Dissatisfied,Dissatisfied';
            OptionMembers = " ","Very Satisfied",Satisfied,"Very Dissatisfied",Dissatisfied;
        }
        field(31; Appointment; Option)
        {
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(32; "Appointment Date"; Date)
        {
        }
        field(33; "Appointment Time"; Time)
        {
        }
        field(34; Remarks; Text[100])
        {
        }
        field(35; "Contact By"; Code[50])
        {
        }
        field(36; "Contact Type"; Option)
        {
            Editable = false;
            OptionCaption = ' ,7th Contact,30th Contact,Contacted';
            OptionMembers = " ","7th Contact","30th Contact",Contacted;
        }
        field(37; "Accountability Center"; Code[10])
        {
            TableRelation = "Accountability Center".Code;
        }
        field(38; "Vehicle Serial No."; Code[20])
        {
            TableRelation = Vehicle;
        }
        field(39; "Model Version No."; Code[20])
        {
        }
        field(40; "Make Code"; Code[20])
        {
        }
        field(41; Contacted; Boolean)
        {
            Editable = true;
        }
    }

    keys
    {
        key(Key1; "No.", "Contact Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        PostSalesContact.RESET;
        IF PostSalesContact.FINDLAST THEN
            "No." := PostSalesContact."No." + 1
        ELSE
            "No." := 1;
    end;

    var
        VehRec: Record "25006005";
        Customer: Record "18";
        PostSalesContact: Record "33019863";
}

