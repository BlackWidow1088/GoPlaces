import { TestBed } from '@angular/core/testing';

import { GpNetworkService } from './gp-network.service';

describe('GpNetworkService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: GpNetworkService = TestBed.get(GpNetworkService);
    expect(service).toBeTruthy();
  });
});
