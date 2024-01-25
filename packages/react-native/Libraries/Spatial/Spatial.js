import NativeSpatialManager from "./NativeSpatialManager";

const Spatial = {
  openImmersiveSpace: (sceneId?: string) => { 
    return NativeSpatialManager.openImmersiveSpace(sceneId);
  },
  dismissImmersiveSpace: () => {
    return NativeSpatialManager.dismissImmersiveSpace();
  },
};

module.exports = Spatial;
