/*
 * Header file for: SM_Coder_FSM_PLL_ACC_Multifunction/Circuit/LaunchPad
 * Generated with : PLECS 4.4.5
 *                  TI2837xS 1.2
 * Generated on   : 5 Aug 2021 17:57:03
 */

#ifndef PLECS_HEADER_LaunchPad_h_
#define PLECS_HEADER_LaunchPad_h_
#include <stdbool.h>
#include <stdint.h>

/* Target declarations */
typedef int_fast8_t int8_t;
typedef uint_fast8_t uint8_t;
extern void LaunchPad_background(void);

/* Model floating point type */
typedef double LaunchPad_FloatType;

/* Model checksum */
extern const char * const LaunchPad_checksum;

/* Model error status */
extern const char * LaunchPad_errorStatus;

/* Model sample time */
extern const double LaunchPad_sampleTime;

/*
 * Model states */
typedef struct {
  double Integrator_x;                 /* /LaunchPad/Controller/SRF Phas-Locked Loop/Integrator */
  double HPF[2];                       /* /LaunchPad/Controller/Alternating-Current Control2/AD 2/HPF */
  double LPF[2];                       /* /LaunchPad/Controller/Alternating-Current Control2/VFF/LPF */
  double StateMachine[6];              /* /LaunchPad/State Machine */
  double HPF_1[2];                     /* /LaunchPad/Controller/Alternating-Current Control2/VDC_derivative/HPF */
  double Integrator_1_x;               /* /LaunchPad/Controller/Alternating-Current Control2/dd-axis Virtual Damping Control/Integrator */
  double Integrator_2_x;               /* /LaunchPad/Controller/Alternating-Current Control2/d-axis PI Regulator/Integrator */
  bool Integrator_2_prevReset;         /* /LaunchPad/Controller/Alternating-Current Control2/d-axis PI Regulator/Integrator */
  double Integrator_3_x;               /* /LaunchPad/Controller/Alternating-Current Control2/qq-axis Virtual Damping Control/Integrator */
  double Integrator_4_x;               /* /LaunchPad/Controller/Alternating-Current Control2/q-axis PI Regulator/Integrator */
  bool Integrator_4_prevReset;         /* /LaunchPad/Controller/Alternating-Current Control2/q-axis PI Regulator/Integrator */
  double Delay[3];                     /* /LaunchPad/Delay */
  double Integrator_5_x;               /* /LaunchPad/Controller/SRF Phas-Locked Loop/PLL PI Regulator/Integrator */
  bool Integrator_5_prevReset;         /* /LaunchPad/Controller/SRF Phas-Locked Loop/PLL PI Regulator/Integrator */
} LaunchPad_ModelStates;

extern LaunchPad_ModelStates LaunchPad_X;

/* Block outputs */
typedef struct {
  double StateMachine[10];             /* /LaunchPad/State Machine */
  double Saturation;                   /* /LaunchPad/ADC Decode/Saturation */
  double Saturation_1[3];              /* /LaunchPad/Controller/Alternating-Current Control2/Saturation */
  double Delay[3];                     /* /LaunchPad/Delay */
  double Fcn3;                         /* /LaunchPad/ADC Decode/Calibration/With calibration/Fcn3 */
  double Integrator;                   /* /LaunchPad/Controller/SRF Phas-Locked Loop/Integrator */
  bool CompareToConstant;              /* /LaunchPad/Controller/SRF Phas-Locked Loop/Compare to Constant */
  double Integrator_i1;                /* /LaunchPad/Controller/SRF Phas-Locked Loop/Integrator */
  double Cos;                          /* /LaunchPad/Controller/Alternating-Current Control2/3ph->RRF9/Cos */
  double Fcn4;                         /* /LaunchPad/ADC Decode/Calibration/With calibration/Fcn4 */
  double Sin;                          /* /LaunchPad/Controller/Alternating-Current Control2/3ph->RRF9/Sin */
  double Fcn5;                         /* /LaunchPad/ADC Decode/Calibration/With calibration/Fcn5 */
  double abc_d;                        /* /LaunchPad/Controller/Alternating-Current Control2/3ph->RRF9/abc->d */
  double abc_q;                        /* /LaunchPad/Controller/Alternating-Current Control2/3ph->RRF9/abc->q */
  bool Switch;                         /* /LaunchPad/Controller/Alternating-Current Control2/AD 2/Switch */
  bool Switch_1;                       /* /LaunchPad/Controller/Alternating-Current Control2/VFF/Switch */
  double ADCB[4];                      /* /LaunchPad/ADC B */
  double Fcn;                          /* /LaunchPad/ADC Decode/Calibration/With calibration/Fcn */
  double Fcn1;                         /* /LaunchPad/ADC Decode/Calibration/With calibration/Fcn1 */
  double Fcn2;                         /* /LaunchPad/ADC Decode/Calibration/With calibration/Fcn2 */
  double SW_OLPLL;                     /* /LaunchPad/SW_OLPLL */
  double SW_ACC;                       /* /LaunchPad/SW_ACC */
  double SW_CTRL_BW;                   /* /LaunchPad/SW_CTRL_BW */
  double SW_OPTION_BW;                 /* /LaunchPad/SW_OPTION_BW */
  double Switch_2;                     /* /LaunchPad/Controller/Alternating-Current Control2/Switch */
  double Cos_1;                        /* /LaunchPad/Controller/Alternating-Current Control2/3ph->RRF7/Cos */
  double Sin_1;                        /* /LaunchPad/Controller/Alternating-Current Control2/3ph->RRF7/Sin */
  double abc_d_1;                      /* /LaunchPad/Controller/Alternating-Current Control2/3ph->RRF7/abc->d */
  bool Switch_3;                       /* /LaunchPad/Controller/Alternating-Current Control2/VDC_derivative/Switch */
  double Integrator_1;                 /* /LaunchPad/Controller/Alternating-Current Control2/dd-axis Virtual Damping Control/Integrator */
  double SW_VDC;                       /* /LaunchPad/SW_VDC */
  double Sum;                          /* /LaunchPad/Controller/Alternating-Current Control2/Sum */
  double Integrator_2;                 /* /LaunchPad/Controller/Alternating-Current Control2/d-axis PI Regulator/Integrator */
  double abc_q_1;                      /* /LaunchPad/Controller/Alternating-Current Control2/3ph->RRF7/abc->q */
  double Sum9;                         /* /LaunchPad/Controller/Alternating-Current Control2/Sum9 */
  double Cos_2;                        /* /LaunchPad/Controller/Alternating-Current Control2/RRF->3ph/Cos */
  double Integrator_3;                 /* /LaunchPad/Controller/Alternating-Current Control2/qq-axis Virtual Damping Control/Integrator */
  double Sum2;                         /* /LaunchPad/Controller/Alternating-Current Control2/Sum2 */
  double Integrator_4;                 /* /LaunchPad/Controller/Alternating-Current Control2/q-axis PI Regulator/Integrator */
  double Sum10;                        /* /LaunchPad/Controller/Alternating-Current Control2/Sum10 */
  double Sin_2;                        /* /LaunchPad/Controller/Alternating-Current Control2/RRF->3ph/Sin */
  double dq_a;                         /* /LaunchPad/Controller/Alternating-Current Control2/RRF->3ph/dq->a */
  double dq_b;                         /* /LaunchPad/Controller/Alternating-Current Control2/RRF->3ph/dq->b */
  double Gain3[3];                     /* /LaunchPad/Controller/Alternating-Current Control2/Gain3 */
  double Cos_3;                        /* /LaunchPad/Controller/OL/RRF->3ph/Cos */
  double Sin_3;                        /* /LaunchPad/Controller/OL/RRF->3ph/Sin */
  double dq_a_1;                       /* /LaunchPad/Controller/OL/RRF->3ph/dq->a */
  double dq_b_1;                       /* /LaunchPad/Controller/OL/RRF->3ph/dq->b */
  bool Switch_4;                       /* /LaunchPad/Controller/output selector/Switch */
  bool Switch1;                        /* /LaunchPad/Controller/output selector/Switch1 */
  double Switch1_i1[3];                /* /LaunchPad/Controller/output selector/Switch1 */
  bool Switch_5;                       /* /LaunchPad/Switch */
  double Switch1_1;                    /* /LaunchPad/Controller/SRF Phas-Locked Loop/Switch1 */
  double Sin_4;                        /* /LaunchPad/Controller/SRF Phas-Locked Loop/3ph->RRF/Sin */
  double Cos_4;                        /* /LaunchPad/Controller/SRF Phas-Locked Loop/3ph->RRF/Cos */
  double abc_q_2;                      /* /LaunchPad/Controller/SRF Phas-Locked Loop/3ph->RRF/abc->q */
  double Integrator_5;                 /* /LaunchPad/Controller/SRF Phas-Locked Loop/PLL PI Regulator/Integrator */
  double Sum3;                         /* /LaunchPad/Controller/SRF Phas-Locked Loop/Sum3 */
  double Product2;                     /* /LaunchPad/Controller/SRF Phas-Locked Loop/PLL PI Regulator/Product2 */
  double Gain2;                        /* /LaunchPad/Controller/Alternating-Current Control2/dd-axis Virtual Damping Control/Gain2 */
  double Gain2_1;                      /* /LaunchPad/Controller/Alternating-Current Control2/d-axis PI Regulator/Gain2 */
  double Gain2_2;                      /* /LaunchPad/Controller/Alternating-Current Control2/qq-axis Virtual Damping Control/Gain2 */
  double Gain2_3;                      /* /LaunchPad/Controller/Alternating-Current Control2/q-axis PI Regulator/Gain2 */
} LaunchPad_BlockOutputs;

extern LaunchPad_BlockOutputs LaunchPad_B;

/* Entry point functions */
void LaunchPad_initialize(double time);
void LaunchPad_step(void);
void LaunchPad_terminate(void);

#endif                                 /* PLECS_HEADER_LaunchPad_h_ */
