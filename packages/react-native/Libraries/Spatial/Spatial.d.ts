
export interface SpatialStatic {
  openImmersiveSpace(spaceId: string): Promise<void>;
  dismissImmersiveSpace(spaceId: string): Promise<void>;
}

export const Spatial: SpatialStatic;
export type Spatial = SpatialStatic;
