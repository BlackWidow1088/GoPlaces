import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { GpNetworkComponent } from './gp-network.component';

describe('GpNetworkComponent', () => {
  let component: GpNetworkComponent;
  let fixture: ComponentFixture<GpNetworkComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ GpNetworkComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(GpNetworkComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
