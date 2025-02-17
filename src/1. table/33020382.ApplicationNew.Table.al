table 33020382 "Application New"
{

    fields
    {
        field(1; "Application No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Application No." <> xRec."Application No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."Application Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Vacancy No."; Code[20])
        {
            TableRelation = "Vacancy Header New" WHERE(Posted By=FILTER(<>''));
        }
        field(3;"Vacancy Code";Code[20])
        {
            Description = 'to be reomved';
            TableRelation = "Vacancy Header New";
        }
        field(4;"Position Applied";Text[70])
        {
        }
        field(5;"First Name";Text[31])
        {
        }
        field(6;"Middle Name";Text[32])
        {
        }
        field(7;"Last Name";Text[33])
        {
        }
        field(8;DOB;Date)
        {
        }
        field(9;"Marital Status";Option)
        {
            Description = ' ,Single,Married';
            OptionCaption = ' ,Single,Married';
            OptionMembers = " ",Single,Married;
        }
        field(10;Gender;Option)
        {
            Description = ' ,Male,Female';
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(11;Nationality;Option)
        {
            Description = ' ,Nepalese,Indian';
            OptionCaption = ' ,Nepalese,Indian';
            OptionMembers = " ",Nepalese,Indian;
        }
        field(12;P_WardNo;Code[41])
        {
        }
        field(13;P_Vdc_Np;Text[34])
        {
        }
        field(14;P_District;Text[20])
        {
        }
        field(16;T_WardNo;Code[35])
        {
        }
        field(17;T_Vdc_Np;Text[36])
        {
        }
        field(18;T_District;Text[20])
        {
        }
        field(20;Email;Text[50])
        {
        }
        field(21;Telephone;Text[35])
        {
        }
        field(22;CellPhone;Text[35])
        {
        }
        field(23;M_Faculty;Text[50])
        {
        }
        field(24;M_College;Text[75])
        {
        }
        field(25;M_University;Text[75])
        {
        }
        field(26;M_Percentage;Text[30])
        {
        }
        field(27;M_PassedYear;Text[25])
        {
        }
        field(28;B_Faculty;Text[50])
        {
        }
        field(29;B_College;Text[75])
        {
        }
        field(30;B_University;Text[75])
        {
        }
        field(31;B_Percentage;Text[20])
        {
        }
        field(32;B_PassedYear;Text[15])
        {
        }
        field(33;I_Faculty;Text[35])
        {
        }
        field(34;I_College;Text[75])
        {
        }
        field(35;I_University;Text[75])
        {
        }
        field(36;I_Percentage;Text[20])
        {
        }
        field(37;I_PassedYear;Text[15])
        {
        }
        field(38;S_Faculty;Text[35])
        {
        }
        field(39;S_College;Text[75])
        {
        }
        field(40;S_University;Text[75])
        {
        }
        field(41;S_Percentage;Text[15])
        {
        }
        field(42;S_PassedYear;Text[20])
        {
        }
        field(43;O_Faculty;Text[35])
        {
        }
        field(44;O_College;Text[50])
        {
        }
        field(45;O_University;Text[50])
        {
        }
        field(46;O_Percentage;Text[20])
        {
        }
        field(47;O_PassedYear;Text[15])
        {
        }
        field(48;WE1_SN;Option)
        {
            OptionMembers = ,"1","-";
        }
        field(49;WE1_Orgnization;Text[50])
        {
        }
        field(50;WE1_Department;Text[50])
        {
        }
        field(51;WE1_Position;Text[40])
        {
        }
        field(52;WE1_Duration;Decimal)
        {
        }
        field(53;WE2_SN;Option)
        {
            OptionMembers = ,"2","-";
        }
        field(54;WE2_Orgnization;Text[50])
        {
        }
        field(55;WE2_Department;Text[50])
        {
        }
        field(56;WE2_Position;Text[40])
        {
        }
        field(57;WE2_Duration;Decimal)
        {
        }
        field(58;WE3_SN;Option)
        {
            OptionMembers = ,"3","-";
        }
        field(59;WE3_Orgnization;Text[50])
        {
        }
        field(60;WE3_Department;Text[50])
        {
        }
        field(61;WE3_Position;Text[40])
        {
        }
        field(62;WE3_Duration;Decimal)
        {
        }
        field(63;WE4_SN;Option)
        {
            OptionMembers = ,"4","-";
        }
        field(64;WE4_Orgnization;Text[50])
        {
        }
        field(65;WE4_Department;Text[50])
        {
        }
        field(66;WE4_Position;Text[40])
        {
        }
        field(67;WE4_Duration;Decimal)
        {
        }
        field(68;WE5_SN;Option)
        {
            OptionMembers = ,"5","-";
        }
        field(69;WE5_Orgnization;Text[50])
        {
        }
        field(70;WE5_Department;Text[50])
        {
        }
        field(71;WE5_Position;Text[40])
        {
        }
        field(72;WE5_Duration;Decimal)
        {
        }
        field(73;Ref1_SN;Option)
        {
            OptionMembers = ,"1","-";
        }
        field(74;Ref1_FullName;Text[50])
        {
        }
        field(75;Ref1_Relationship;Text[50])
        {
        }
        field(76;Ref1_Company;Text[50])
        {
        }
        field(77;Ref1_Phone;Text[20])
        {
        }
        field(78;Ref1_Address;Text[50])
        {
        }
        field(79;Ref2_SN;Option)
        {
            OptionMembers = ,"2","-";
        }
        field(80;Ref2_FullName;Text[50])
        {
        }
        field(81;Ref2_Relationship;Text[50])
        {
        }
        field(82;Ref2_Company;Text[50])
        {
        }
        field(83;Ref2_Phone;Text[20])
        {
        }
        field(84;Ref2_Address;Text[50])
        {
        }
        field(85;Language;Text[50])
        {
        }
        field(86;"Computer Knowledge";Text[70])
        {
        }
        field(87;"Driving License";Option)
        {
            OptionMembers = " ",Yes,No;
        }
        field(88;Vehicle;Option)
        {
            OptionMembers = " ",Yes,No;
        }
        field(89;Awards;Text[120])
        {
        }
        field(90;"Expected Salary";Text[30])
        {
        }
        field(91;"Posted By";Text[50])
        {
        }
        field(92;"No. Series";Code[20])
        {
            Description = '.';
            TableRelation = "No. Series".Code;
        }
        field(93;ShortList;Boolean)
        {
        }
        field(94;"Written Exam";Boolean)
        {
        }
        field(95;"Written Marks";Decimal)
        {
        }
        field(96;"Written Remarks";Text[50])
        {
        }
        field(97;Interview;Boolean)
        {
        }
        field(98;"Interview Marks";Option)
        {
            OptionMembers = " ","1","2","3","4","5","6","7","8","9","10";
        }
        field(99;"Interview Remarks";Text[50])
        {
        }
        field(100;Selected;Boolean)
        {
        }
        field(101;Reject;Boolean)
        {
        }
        field(102;Employed;Boolean)
        {
        }
        field(103;"Father Name";Text[50])
        {
        }
        field(104;"GrandFather Name";Text[50])
        {
        }
        field(105;"Citizenship No.";Text[20])
        {
        }
        field(106;"Issue Office";Text[30])
        {
        }
        field(107;"Issue District";Text[30])
        {
        }
        field(108;"Medical Certificate No.";Text[15])
        {
        }
        field(109;"Posted by- Shortlist";Code[50])
        {
        }
        field(110;"Posted by- Written Exam";Code[20])
        {
        }
        field(111;"Posted Date- Shortlist";Date)
        {
        }
        field(112;"Posted Date- Written Exam";Date)
        {
        }
        field(113;"Posted by- Interview";Code[50])
        {
        }
        field(114;"Posted Date- Interview";Date)
        {
        }
        field(115;"Postd by- Select";Code[50])
        {
        }
        field(116;"Postd Date- Select";Date)
        {
        }
        field(117;"Posted by- Reject";Code[50])
        {
        }
        field(118;"Posted Date- Reject";Date)
        {
        }
        field(119;"Posted by- Employed";Code[50])
        {
        }
        field(120;"Posted Date- Employed";Date)
        {
        }
        field(121;Status;Option)
        {
            OptionMembers = " ",Shortlist,Reject,Interview,Writtern,Converted;
        }
        field(122;"Employed Date";Date)
        {
        }
        field(123;"Offer Sent Date";Date)
        {
        }
        field(124;"Employee No.";Code[20])
        {
            TableRelation = Employee;
        }
        field(125;"Employee Req Code";Code[20])
        {
            TableRelation = "Emp Requisition Form" WHERE (Approved Date=FILTER(<>''));
        }
    }

    keys
    {
        key(Key1;"Application No.")
        {
            Clustered = true;
        }
        key(Key2;"Vacancy Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Application No." = '' THEN BEGIN
          HRSetup.GET;
          HRSetup.TESTFIELD("Application Nos.");
          NoSeriesMngt.InitSeries(HRSetup."Application Nos.",xRec."No. Series",0D,"Application No.","No. Series");
        END;
         "Posted By" := USERID
    end;

    var
        HRSetup: Record "5218";
        NoSeriesMngt: Codeunit "396";
        ApplicationNew: Record "33020382";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        WITH ApplicationNew DO BEGIN
          ApplicationNew := Rec;
          HRSetup.GET;
          HRSetup.TESTFIELD("Application Nos.");
          IF NoSeriesMngt.SelectSeries(HRSetup."Application Nos.",xRec."No. Series","No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD("Application Nos.");
            NoSeriesMngt.SetSeries("Application No.");
            Rec := ApplicationNew;
            EXIT(TRUE);
          END;
        END;
    end;
}

