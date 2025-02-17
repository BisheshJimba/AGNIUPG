table 14125605 "PSF History"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Description = 'SO No.';
        }
        field(2; VIN; Code[50])
        {
        }
        field(3; Make; Code[20])
        {
        }
        field(4; Model; Code[20])
        {
        }
        field(5; "Model Version"; Code[20])
        {
        }
        field(6; "KM/HR"; Decimal)
        {
        }
        field(8; "Date In"; Date)
        {
        }
        field(9; "Time In"; Time)
        {
        }
        field(10; "Date Out"; Date)
        {
        }
        field(11; "Time Out"; Time)
        {
        }
        field(12; "Delay Reason"; Text[150])
        {
            Description = '--';
        }
        field(13; "Job Card No."; Code[20])
        {
        }
        field(14; "Parts Amount"; Decimal)
        {
        }
        field(15; "Labour Amount"; Decimal)
        {
        }
        field(16; "Lube Qty"; Decimal)
        {
        }
        field(17; "Vehicle Redg No."; Code[30])
        {
        }
        field(18; "Customer Code"; Code[20])
        {
        }
        field(19; "Customer Name"; Text[100])
        {
        }
        field(20; "Contact No."; Text[30])
        {
        }
        field(21; "Alernative Contact"; Text[30])
        {
        }
        field(22; "Location Code"; Code[20])
        {
        }
        field(23; "Action Taken"; Text[200])
        {
        }
        field(24; "Revisit Repair"; Code[20])
        {
        }
        field(25; "Revisit Repair Reason"; Text[200])
        {
        }
        field(26; Remarks; Text[200])
        {
        }
        field(27; "Posted Invoice No."; Code[30])
        {
        }
        field(50056; "RV RR Code"; Option)
        {
            Description = 'PSF';
            OptionCaption = ' ,Revisit,Repeat Repair';
            OptionMembers = " ",Revisit,"Repeat Repair";
        }
        field(50057; "Odometer Reading"; Integer)
        {
        }
        field(50058; "Service Type"; Code[20])
        {
        }
        field(50059; "User Code"; Code[50])
        {
            Description = 'CS Connect ID';
        }
        field(50060; CAPS; Text[30])
        {
        }
        field(50061; "Distributor Branch Delaer"; Code[20])
        {
        }
        field(50062; "Distributor Name"; Text[100])
        {
        }
        field(50063; "Customer Verbatism"; Text[200])
        {
        }
        field(50064; "SA Code M skill"; Code[20])
        {
            Description = 'Salespeople Code';
        }
        field(50065; "Tech Code M skill"; Code[20])
        {
            Description = 'Resource';
        }
        field(50066; "Repeat Group Code"; Code[20])
        {
        }
        field(50067; "Sales Date"; Date)
        {
        }
        field(50068; "Report Inserted"; Boolean)
        {
        }
        field(50069; "Post Inserted"; Boolean)
        {
        }
        field(50070; "Posting Date"; Date)
        {
        }
        field(50071; "Vehicle Serail No."; Code[30])
        {
        }
        field(50072; Complete; Boolean)
        {
        }
        field(50073; Close; Boolean)
        {
        }
        field(50074; "Repeat Group Justification"; Text[200])
        {
        }
        field(50075; "Old Delay Reason"; Text[150])
        {
        }
    }

    keys
    {
        key(Key1; "Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

