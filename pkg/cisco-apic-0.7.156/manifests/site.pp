node 'apic.cisco.com' {
	apic { 'SomeAPICConfig' :
		address => 'https://apic',
		user => 'admin',
		password => 'password',
		config_type => 'hash',
		config => { 
			'polUni' => {
				'children' => [
					{
						'fvTenant' => {
							'attributes' => {
								'name' => 'test2',
							},
							'children' => [
								{
									'fvBD' => {
										'attributes' => {
											'name' => 'BD1'
										}
									},
								},
								{
									'fvAp' => {
										'attributes' => {
											'name' => 'WebApplication',
										},
										'children' => [
											{
												'fvAEPg' => {
													'attributes' => {
														'name' => 'WebTier',
													}
												}
											}
										]
									}
								}
							]
						}
					}
				]
			}
		},
		ensure => 'present',
	}

}
