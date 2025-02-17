table 33019802 "IFF Verification"
{

    fields
    {
        field(1; "Loan No."; Code[20])
        {
            Description = 'req  ,Credit Facility Number';
        }
        field(2; Type; Option)
        {
            Description = 'req';
            OptionCaption = ' ,HD,CF,CH,CS,ES,RS,BR';
            OptionMembers = " ",HD,CF,CH,CS,ES,RS,BR;
        }
        field(3; "Segment Identifier"; Text[4])
        {
            Description = 'req';
        }
        field(4; "Data Prov Identification No."; Text[10])
        {
            Description = 'req ,HD,CF';
        }
        field(5; "Reporting Date"; Text[15])
        {
            Description = 'req ,HD';
        }
        field(6; "Reporting Time"; Text[30])
        {
            Description = 'req ,HD';
        }
        field(7; "Date of Prep File"; Text[15])
        {
            Description = 'req ,HD';
        }
        field(8; "Nature of Data"; Text[3])
        {
            Description = 'req ,HD';
        }
        field(9; "IFF Version ID(Commercial)"; Text[10])
        {
            Description = 'req ,HD';
        }
        field(10; "Prev Data Prov ID No."; Text[10])
        {
            Description = 'as need ,CF';
        }
        field(11; "Data Provider Branch ID"; Text[15])
        {
            Description = 'req ,CF';
        }
        field(12; "Prev Data Prov Branch ID"; Text[15])
        {
            Description = 'as need ,CF';
        }
        field(13; "Prev Loan No"; Code[20])
        {
            Description = 'as needed ,CF';
        }
        field(14; "Credit Facility Type"; Text[4])
        {
            Description = 'req ,CF';
        }
        field(15; "Purpose of Credit Facility"; Text[4])
        {
            Description = 'req ,CF';
        }
        field(16; "Ownership Type"; Text[3])
        {
            Description = 'req , CF';
        }
        field(17; "Customer Credit Limit"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'req, Cf';
        }
        field(18; "Credit Facility Sanction Amt"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'req, Cf';
        }
        field(19; "Disbursement Date"; Text[15])
        {
            Description = 'req, CF';
        }
        field(20; "Disbursement Amount"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'req,CF';
        }
        field(21; "Natural Credit Exp Date"; Text[15])
        {
            Description = 'req,CF';
        }
        field(22; "Repayment Frequency"; Text[5])
        {
            Description = 'req,CF';
        }
        field(23; "No. of Installments"; Integer)
        {
            Description = 'as need, CF';
        }
        field(24; "Amount of Installment"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'as need, CF';
        }
        field(25; "Immediate Preceeding Date"; Text[15])
        {
            Description = 'as need, CF';
        }
        field(26; "Total Outstanding Balance"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'as need, CF';
        }
        field(27; "Highest Credit Usage"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CF';
        }
        field(28; "Date of Last Repay"; Text[15])
        {
            Description = 'CF';
        }
        field(29; "Last Repay Amount"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CF';
        }
        field(30; "Payment Delay Days"; Integer)
        {
            Description = 'CF,CH';
        }
        field(31; "Payment Delay Indicator"; Text[3])
        {
            Description = 'CF';
        }
        field(32; "Number of days over due"; Integer)
        {
            Description = 'CF';
        }
        field(33; "Amount OverDue"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CF';
        }
        field(34; "Amount OverDue 1-30 Days"; Decimal)
        {
            Description = 'CF';
        }
        field(35; "Amount OverDue 31-60 Days"; Decimal)
        {
            Description = 'CF';
        }
        field(36; "Amount OverDue 61-90 Days"; Decimal)
        {
            Description = 'CF';
        }
        field(37; "Amount OverDue 91-120 Days"; Decimal)
        {
            Description = 'CF';
        }
        field(38; "Amount OverDue 121-150 Days"; Decimal)
        {
            Description = 'CF';
        }
        field(39; "Amount OverDue 151-180 Days"; Decimal)
        {
            Description = 'CF';
        }
        field(40; "Amount  Overdue 181 or More"; Decimal)
        {
            Description = 'CF';
        }
        field(41; "Assets Classification"; Text[15])
        {
            Description = 'CF';
        }
        field(42; "Credit Facility Status"; Text[3])
        {
            Description = 'CF';
        }
        field(43; "Credit Facility Closing Date"; Text[15])
        {
            Description = 'CF';
        }
        field(44; "Reason for Closure"; Text[3])
        {
            Description = 'CF';
        }
        field(45; "Security Coverage Flag"; Text[3])
        {
            Description = 'CF';
        }
        field(46; "Legal Action Taken"; Text[3])
        {
            Description = 'CF';
        }
        field(47; "Info Update On"; Text[15])
        {
            Description = 'CF';
        }
        field(48; "Time of Update"; Text[10])
        {
            Description = 'CF';
        }
        field(49; "Date Reported"; Text[15])
        {
            Description = 'CH ,New';
        }
        field(50; "Installment Due Date"; Text[15])
        {
            Description = 'CH';
        }
        field(51; "Payment Due Settlment Date"; Text[15])
        {
            Description = 'CH';
        }
        field(53; "Customer No."; Code[20])
        {
            Description = 'CS , New';
        }
        field(54; "Prev Customer No."; Code[20])
        {
            Description = 'CS';
        }
        field(55; "Subject Name"; Text[50])
        {
        }
        field(56; "Subject Prev Name"; Text[30])
        {
        }
        field(58; "Date of Comp Redg"; Text[15])
        {
        }
        field(59; PAN; Code[20])
        {
        }
        field(60; "Previous PAN"; Code[20])
        {
        }
        field(61; "PAN Issue Date"; Text[15])
        {
        }
        field(62; "PAN Issue District"; Text[3])
        {
        }
        field(63; "Comp Redg No."; Code[20])
        {
        }
        field(64; "Comp Redg Issued Authority"; Text[10])
        {
        }
        field(65; "Address1 Type"; Text[3])
        {
        }
        field(66; "Address1 Line 1"; Text[50])
        {
        }
        field(67; "Address1 Line 2"; Text[50])
        {
        }
        field(68; "Address1 Line 3"; Text[50])
        {
        }
        field(69; "Address1 District"; Text[50])
        {
        }
        field(70; "Address1 PO Box"; Text[10])
        {
        }
        field(71; "Telephone 1"; Text[15])
        {
            Description = 'hard code put +977';
        }
        field(72; "Mobile Number"; Text[15])
        {
        }
        field(73; "Business Activity Code"; Code[20])
        {
        }
        field(74; "Fax 1"; Text[20])
        {
        }
        field(75; "Email Address"; Text[100])
        {
        }
        field(77; "Related Entity Type"; Text[3])
        {
            Description = 'RS';
        }
        field(78; "Nature of Relation Ship"; Text[3])
        {
        }
        field(79; "Related Entities Name"; Text[50])
        {
        }
        field(80; "Legal Status"; Text[3])
        {
        }
        field(81; "Date of Birth Comp Redg"; Text[12])
        {
        }
        field(82; "RE Comp Redg No."; Text[20])
        {
        }
        field(83; "RE Comp Reg No. Issued Auth"; Text[10])
        {
        }
        field(84; "RE Citizenship No."; Text[20])
        {
        }
        field(85; "RE Prev Citizenship No."; Text[20])
        {
        }
        field(86; "RE Citizenship No. Issued Date"; Text[15])
        {
        }
        field(87; "RE Citizen No. Issued District"; Text[3])
        {
        }
        field(88; "RE PAN"; Text[20])
        {
        }
        field(89; "RE Previous PAN"; Text[20])
        {
        }
        field(90; "RE PAN No. Issue Date"; Text[15])
        {
        }
        field(91; "RE PAN issued District"; Text[10])
        {
        }
        field(92; "RE Passport"; Text[20])
        {
        }
        field(93; "RE Previous Passport"; Text[20])
        {
        }
        field(94; "Passport No. Expiry Date"; Text[15])
        {
        }
        field(95; "RE Voter ID"; Text[20])
        {
        }
        field(96; "RE Previous Voter ID"; Text[20])
        {
        }
        field(97; "RE Voter ID No. Issued Date"; Text[15])
        {
        }
        field(98; "IN Embassy Reg No."; Text[20])
        {
        }
        field(99; "IN Embasssy Reg No. Issue Date"; Text[15])
        {
        }
        field(100; "Percentage of Control"; Decimal)
        {
        }
        field(101; "Guarantee Type"; Text[3])
        {
        }
        field(102; "Date of Leaving"; Text[15])
        {
        }
        field(103; "Father Name"; Text[50])
        {
        }
        field(104; "Grand Father Name"; Text[50])
        {
        }
        field(105; "Spouse1 Name"; Text[50])
        {
        }
        field(106; "Spouse2 Name"; Text[50])
        {
        }
        field(107; "Mother Name"; Text[50])
        {
        }
        field(108; "Related Indiv Nationality"; Text[3])
        {
        }
        field(109; "RE Gender"; Text[7])
        {
        }
        field(110; "RE Entities Address Type"; Text[3])
        {
        }
        field(111; "RE Entities Address"; Text[50])
        {
        }
        field(112; "RE Entities Address Line 2"; Text[50])
        {
        }
        field(113; "RE Entities Address Line 3"; Text[50])
        {
        }
        field(114; "RE Entities Address District"; Text[3])
        {
        }
        field(115; "RE Entities Address P.O Box No"; Text[10])
        {
        }
        field(116; "RE Entities Address Country"; Text[3])
        {
        }
        field(117; "RE Entities Telephone No.1"; Text[20])
        {
        }
        field(118; "RE Entities Telephone No.2"; Text[20])
        {
        }
        field(119; "Related Indv. Mobile No."; Text[20])
        {
        }
        field(120; Fax1; Text[20])
        {
        }
        field(121; Fax2; Text[20])
        {
        }
        field(122; "RE Entities Email Address"; Text[50])
        {
        }
        field(123; Group; Text[3])
        {
        }
        field(125; "RE Type"; Text[3])
        {
            Description = 'BR';
        }
        field(126; "Nature of Relationship"; Text[3])
        {
        }
        field(127; "BR RE Name"; Text[50])
        {
        }
        field(129; "BR RE DOB/Date of Reg"; Text[15])
        {
        }
        field(130; "BR RE Comp Reg No."; Text[20])
        {
        }
        field(131; "BR RE Comp Reg No. Issue Auth"; Text[3])
        {
        }
        field(132; "BR RE Citizenship No."; Text[20])
        {
        }
        field(133; "BR RE Prev. Citizenship No."; Text[20])
        {
        }
        field(134; "BR RE Citizen No. Issued Date"; Text[15])
        {
        }
        field(135; "BR RE Citizen No. Issue Dist"; Text[3])
        {
        }
        field(136; "BR RE PAN"; Text[20])
        {
        }
        field(137; "BR RE Prev. PAN"; Text[20])
        {
        }
        field(138; "BR RE PAN No. Issued Date"; Text[15])
        {
        }
        field(139; "BR RE PAN Issued District"; Text[3])
        {
        }
        field(140; "BR RE Passport"; Text[20])
        {
        }
        field(141; "BR RE Previous Passport"; Text[20])
        {
        }
        field(142; "BR RE Passport No. Exp Date"; Text[15])
        {
        }
        field(143; "BR RE Voter ID"; Text[20])
        {
        }
        field(144; "BR RE Prev. Voter ID"; Text[20])
        {
        }
        field(145; "BR RE Voter ID No. Issued Date"; Text[15])
        {
        }
        field(146; "BR RE IN Emb Reg No. Issue Dat"; Text[15])
        {
        }
        field(147; "BR RE Gender"; Text[3])
        {
        }
        field(148; "BR RE Percentage of control"; Decimal)
        {
        }
        field(149; "BR RE Date of Leaving"; Text[15])
        {
        }
        field(150; "BR RE Father Name"; Text[50])
        {
        }
        field(151; "BR RE Grand Father Name"; Text[50])
        {
        }
        field(152; "BR RE Spouse1 Name"; Text[50])
        {
        }
        field(153; "BR RE Spouse2 Name"; Text[50])
        {
        }
        field(154; "BR RE Mother Name"; Text[50])
        {
        }
        field(155; "BR Nationality"; Text[3])
        {
        }
        field(156; "BR RE Address Type"; Text[15])
        {
        }
        field(157; "BR RE Address Line 1"; Text[50])
        {
        }
        field(158; "BR RE Address Line 2"; Text[50])
        {
        }
        field(159; "BR RE Address Line 3"; Text[50])
        {
        }
        field(160; "BR RE District"; Text[3])
        {
        }
        field(161; "BR RE P.O. Box"; Text[10])
        {
        }
        field(162; "BR RE Country"; Text[3])
        {
        }
        field(163; "BR RE Telephone No. 1"; Text[20])
        {
        }
        field(164; "BR RE Telephone No. 2"; Text[20])
        {
        }
        field(165; "BR RE Mobile No."; Text[20])
        {
        }
        field(166; "BR RE Fax 1"; Text[20])
        {
        }
        field(167; "BR RE Fax2"; Text[20])
        {
        }
        field(168; "BR RE Email"; Text[50])
        {
        }
        field(169; "Last Modified Date"; Date)
        {
        }
        field(170; "Credit Facilty Open Date"; Text[30])
        {
        }
        field(171; "Address1 Country"; Text[30])
        {
        }
        field(172; "Address 2 Type"; Text[30])
        {
        }
        field(173; "Address 2 Line 1"; Text[30])
        {
        }
        field(174; "Address 2 Line 2"; Text[30])
        {
        }
        field(175; "Address 2 Line 3"; Text[30])
        {
        }
        field(176; "Address 2 District"; Text[30])
        {
        }
        field(177; "Address 2 Power BOX"; Text[30])
        {
        }
        field(178; "Address 2 Country"; Text[30])
        {
        }
        field(179; "Telephone Number 2"; Code[20])
        {
        }
        field(180; "Credit Facilty Sanction Curr"; Text[10])
        {
        }
        field(181; "IFF Version ID(Consumer)"; Text[5])
        {
        }
        field(182; "Currency Code"; Text[10])
        {
        }
        field(183; "Citizenship Number"; Text[20])
        {
        }
        field(184; "Prev Citizenship Number"; Text[20])
        {
        }
        field(185; "Citizenship Issued District"; Text[20])
        {
        }
        field(186; Passport; Text[20])
        {
        }
        field(187; "Prev Passport"; Text[20])
        {
        }
        field(188; "Voter ID"; Text[20])
        {
        }
        field(189; "Prev Voter ID"; Text[20])
        {
        }
        field(190; "Voter ID no issued Date"; Text[20])
        {
        }
        field(191; "Subject Nationality"; Text[20])
        {
        }
        field(192; "Marital Status"; Text[10])
        {
        }
        field(193; "Date of Birth"; Text[12])
        {
        }
        field(194; Gender; Text[10])
        {
        }
        field(195; "RE Address 1 Line 1"; Text[20])
        {
        }
        field(196; "BR Re In Emb Regd No"; Text[20])
        {
        }
        field(197; "Employment Type"; Text[10])
        {
        }
        field(198; "Employer Name"; Text[30])
        {
        }
        field(199; "Employement Comm Regd ID"; Text[20])
        {
        }
        field(200; "Subject Employer Address"; Text[20])
        {
        }
        field(201; Designation; Text[20])
        {
        }
        field(202; "Monthly Income"; Text[10])
        {
        }
        field(203; "Consumer Segment Identifier"; Text[4])
        {
        }
        field(204; "File Type"; Option)
        {
            OptionMembers = " ",Consumer,Commercial;
        }
        field(205; "Citizenship Issued Date"; Text[15])
        {
            Description = 'Nepali';
        }
        field(206; "BR Entity Type"; Text[5])
        {
        }
        field(207; "No of Installments Overdue"; Integer)
        {
        }
        field(208; "VR Nature of Relationship"; Code[3])
        {
        }
        field(209; "BR Nature of Relationship"; Code[3])
        {
        }
    }

    keys
    {
        key(Key1; "Loan No.", Type, "File Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Last Modified Date" := TODAY;
    end;

    trigger OnModify()
    begin
        "Last Modified Date" := TODAY;
    end;
}

