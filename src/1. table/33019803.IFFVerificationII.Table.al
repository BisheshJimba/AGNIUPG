table 33019803 "IFF Verification II"
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
            OptionCaption = ' ,SS,VS,VR,TL';
            OptionMembers = " ",SS,VS,VR,TL;
        }
        field(3; "Segment Identifier"; Text[4])
        {
            Description = 'req';
        }
        field(4; "Data Prov Identification No."; Text[10])
        {
            Description = 'req ,HD,CF';
        }
        field(170; "Type of Security"; Text[4])
        {
            Description = 'SS';
        }
        field(171; "Security Ownership Type"; Text[3])
        {
        }
        field(172; "Valuator Type"; Text[3])
        {
        }
        field(173; "Description of Security"; Text[150])
        {
        }
        field(174; "Nature of Charge"; Text[3])
        {
        }
        field(175; "Security Coverage Percentage"; Text[6])
        {
        }
        field(176; "Latest Value of Security"; Integer)
        {
        }
        field(177; "Date of Latest Valuation"; Text[12])
        {
        }
        field(178; "Valuator Entity Type"; Text[3])
        {
            Description = 'VS';
        }
        field(179; "Valuator Entity's Name"; Text[100])
        {
        }
        field(180; "Legal Status"; Text[3])
        {
        }
        field(181; "VE DOB/Comp Reg Date"; Text[15])
        {
        }
        field(182; "VE Comp Reg No."; Text[20])
        {
        }
        field(183; "VE Comp Reg No. Issue Auth"; Text[3])
        {
        }
        field(184; "VE Citizenship No"; Text[20])
        {
        }
        field(185; "VE Previous Citizenship No."; Text[20])
        {
        }
        field(186; "VE Citizenship No. Issued Date"; Text[15])
        {
        }
        field(187; "VE Citizenship No. Issued Dist"; Text[3])
        {
        }
        field(188; "VE PAN"; Text[20])
        {
        }
        field(189; "VE Prev PAN"; Text[20])
        {
        }
        field(190; "VE PAN No. Issued Date"; Text[15])
        {
        }
        field(191; "VE PAN No. Isueed District"; Text[3])
        {
        }
        field(192; "VE Passport"; Text[20])
        {
        }
        field(193; "VE Previous Passport"; Text[20])
        {
        }
        field(194; "VE Passport No. Exp Date"; Text[12])
        {
        }
        field(195; "VE Voter ID"; Text[20])
        {
        }
        field(196; "VE Prev Voter ID"; Text[20])
        {
        }
        field(197; "VE Voter ID No. Issued Date"; Text[15])
        {
        }
        field(198; "VE IN EMB Reg No."; Text[20])
        {
        }
        field(199; "VE IN EMB Reg No. Issue Date"; Text[15])
        {
        }
        field(200; "VE Gender"; Text[3])
        {
        }
        field(201; "VE Father's Name"; Text[100])
        {
        }
        field(202; "VE Grand Father's Name"; Text[100])
        {
        }
        field(203; "VE Spouse1 Name"; Text[100])
        {
        }
        field(204; "VE Spouse2 Name"; Text[100])
        {
        }
        field(205; "VE Mother's Name"; Text[100])
        {
        }
        field(206; "VE Address Type"; Text[3])
        {
        }
        field(207; "VE Address Line 1"; Text[100])
        {
        }
        field(208; "VE Address Line 2"; Text[100])
        {
        }
        field(209; "VE Address Line 3"; Text[100])
        {
        }
        field(210; "VE Address District"; Text[3])
        {
        }
        field(211; "VE Address P.O. Box"; Text[10])
        {
        }
        field(212; "VE Address Country"; Text[3])
        {
        }
        field(213; "VE Telephone No. 1"; Text[20])
        {
        }
        field(214; "VE Telephone No. 2"; Text[20])
        {
        }
        field(215; "VE Mobile No."; Text[20])
        {
        }
        field(216; "VE Fax 1"; Text[20])
        {
        }
        field(217; "VE Fax 2"; Text[20])
        {
        }
        field(218; "VE Email"; Text[100])
        {
        }
        field(219; "Valuator Rltn Entity Type"; Text[3])
        {
        }
        field(220; "Nature of Relationship"; Text[3])
        {
        }
        field(221; "VR Name"; Text[100])
        {
        }
        field(223; "VR DOB/Date of Reg"; Text[15])
        {
        }
        field(224; "VR BE Comp Reg No."; Text[20])
        {
        }
        field(225; "VR BE Comp Reg No. Issued Auth"; Text[3])
        {
        }
        field(226; "VR Indv. Citizenship No."; Text[20])
        {
        }
        field(227; "VR Entity's Prev. Citizen No."; Text[20])
        {
        }
        field(229; "VRE Citizen No. Issued Date"; Text[15])
        {
        }
        field(230; "VRE Citizen No. Issued Dist"; Text[3])
        {
        }
        field(231; "VRE PAN"; Text[20])
        {
        }
        field(232; "VRE Prev PAN"; Text[20])
        {
        }
        field(233; "VRE PAN No. Issued Date"; Text[15])
        {
        }
        field(234; "VRE BE PAN issued District"; Text[3])
        {
        }
        field(235; "VRE Passport"; Text[20])
        {
        }
        field(236; "VRE Previous Passport"; Text[20])
        {
        }
        field(237; "VRE Passport No. Exp Date"; Text[15])
        {
        }
        field(238; "VRE Voter ID"; Text[20])
        {
        }
        field(239; "VRE Prev. Voter ID"; Text[20])
        {
        }
        field(240; "VRE Voter ID No. Issued Date"; Text[15])
        {
        }
        field(241; "VRE IN EMB Reg No."; Text[20])
        {
        }
        field(242; "VRE IN EMB Reg Issue Date"; Text[15])
        {
        }
        field(243; "VR Gender"; Text[6])
        {
        }
        field(244; "VR Percentage of Control"; Decimal)
        {
        }
        field(245; "VR Date of Leaving"; Text[15])
        {
        }
        field(246; "VR Father's Name"; Text[100])
        {
        }
        field(247; "VR Grand Father's Name"; Text[100])
        {
        }
        field(248; "VR Spouse1 Name"; Text[100])
        {
        }
        field(249; "VR Spouse2 Name"; Text[100])
        {
        }
        field(250; "VR Mother's Name"; Text[100])
        {
        }
        field(251; "VR Address Type"; Text[3])
        {
        }
        field(252; "VR Address Line 1"; Text[100])
        {
        }
        field(253; "VR Address Line 2"; Text[100])
        {
        }
        field(254; "VR Address Line 3"; Text[100])
        {
        }
        field(255; "VR District"; Text[3])
        {
        }
        field(256; "VR PO BOX"; Text[10])
        {
        }
        field(257; "VR Country"; Text[3])
        {
        }
        field(258; "VR Telephone No.1"; Text[20])
        {
        }
        field(259; "VR Telephone No.2"; Text[20])
        {
        }
        field(260; "VR Mobile No."; Text[20])
        {
        }
        field(261; "VR Fax 1"; Text[20])
        {
        }
        field(262; "VR Email"; Text[100])
        {
        }
        field(263; "Data Provider ID"; Text[15])
        {
            Description = 's';
        }
        field(264; "No. of Credit Facilities"; Integer)
        {
        }
        field(265; "Last Modified Date"; Date)
        {
        }
        field(266; "Data Provider Branch ID"; Code[20])
        {
        }
        field(267; "Customer Number"; Code[20])
        {
        }
        field(268; "Credit Facility Number"; Code[20])
        {
        }
        field(269; "Previous Customer No"; Code[20])
        {
        }
        field(270; Group; Text[30])
        {
        }
        field(271; "VR Entity CitizenNo IssueDate"; Date)
        {
        }
        field(272; "VR Entity CitizenNo IssueDistr"; Text[30])
        {
        }
        field(273; "VR Fax 2"; Text[30])
        {
        }
        field(274; "Consumer Segment Identifier"; Text[4])
        {
        }
        field(275; "File Type"; Option)
        {
            OptionMembers = " ",Consumer,Commercial;
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

